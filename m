Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760993Ab2FDWRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 18:17:47 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:33336 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab2FDWRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 18:17:46 -0400
Date: Tue, 5 Jun 2012 00:18:11 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Chen Gong <gong.chen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "bp@amd64.org" <bp@amd64.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 1/2] x86: mce Cleanup timer mess
Message-ID: <20120604221811.GF30310@aftab.osrc.amd.com>
References: <20120524174943.989990966@linutronix.de>
 <20120524175056.391516712@linutronix.de>
 <4FCC1BE4.3070404@linux.intel.com>
 <3908561D78D1C84285E8C5FCA982C28F192F7E3F@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192F7E3F@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 06:14:38PM +0000, Luck, Tony wrote:
> > Here Thomas changed original mode from "*n = max(*n/2, HZ/100);"
> > to "iv = max(iv, (unsigned long) HZ/100);", which means *iv* will not
> > be decremented but only incremented in _else_ branch. If so, eventually
> > the *iv will be equal to *check_interval*. I don't think it makes sense.
> 
> It looks like Thomas just forgot the "/ 2" there while cleaning up.
> I didn't see it either, nor did Boris when he acked it. Thank goodness
> for your extra eyes looking at this.

We should all pack our bags and go home. :<|

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
