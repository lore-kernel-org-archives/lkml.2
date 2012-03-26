Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819Ab2CZPZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:25:59 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:33259 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559Ab2CZPZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:25:58 -0400
Date: Mon, 26 Mar 2012 17:25:53 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@suse.com>
Subject: Re: [GIT PULL] x86, microcode fixes for 3.2
Message-ID: <20120326152553.GI32090@aftab>
References: <20111128204311.GA2814@aftab>
 <20111202194658.GF15204@aftab>
 <20111205092612.GB29641@elte.hu>
 <20111205151016.GC7834@aftab>
 <4F6F719B.5020806@zytor.com>
 <20120326084810.GA31480@aftab>
 <4F7082BD.9030107@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7082BD.9030107@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 07:52:45AM -0700, H. Peter Anvin wrote:
> On 03/26/2012 01:48 AM, Borislav Petkov wrote:
> > On Sun, Mar 25, 2012 at 12:27:23PM -0700, H. Peter Anvin wrote:
> >> I keep wondering if we couldn't have the early-static trap handlers be
> >> aware of exception tables, too; they wouldn't have to worry about
> >> modules and so it would be reasonably easy.
> > 
> > Well, we talked about this recently and then we decided we needed the
> > extable-sorting-at-build-time patches before we make those static trap
> > handlers aware of extables. What happened to those patches, btw? See
> > thread at http://marc.info/?l=linux-kernel&m=132196692827070
> > 
> 
> Hm... I hope that didn't stall out because of me... the amount of
> overload I have been under lately is a bit scary.
> 
> I was going to dredge out the perfect hash stuff that I had, but the
> sorting stuff could be done without that.

Ok, let me scratch up something in the coming days.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
