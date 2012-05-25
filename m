Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab2EYGQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 02:16:18 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:40253 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab2EYGQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 02:16:17 -0400
Date: Fri, 25 May 2012 08:16:48 +0200
From: Borislav Petkov <bp@amd64.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Chen Gong <gong.chen@linux.intel.com>,
        tony.luck@intel.com, bp@amd64.org, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 1/2] x86: mce Cleanup timer mess
Message-ID: <20120525061647.GA3179@aftab.osrc.amd.com>
References: <20120524174943.989990966@linutronix.de>
 <20120524175056.391516712@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524175056.391516712@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 05:54:51PM +0000, Thomas Gleixner wrote:
> Use unsigned long for dealing with jiffies not int. Rename the
> callback to something sensible. Use __this_cpu_read/write for
> accessing per cpu data.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Looks good to me,

thanks.

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
