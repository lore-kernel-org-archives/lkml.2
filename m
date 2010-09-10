Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab0IJFgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 01:36:06 -0400
Received: from smtp-118-thursday.nerim.net ([62.4.16.118]:61998 "EHLO
	maiev.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752715Ab0IJFgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 01:36:04 -0400
Date: Fri, 10 Sep 2010 07:36:01 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Artur Skawina <art.08.09@gmail.com>
Cc: Nix <nix@esperi.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>,
        John Drescher <drescherjm@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [BISECTED] 2.6.35.*: horrible (exponential? >linear) slowdown
 to unusability (HPET)
Message-ID: <20100910053601.GA4981@brouette>
References: <87zkvx2ese.fsf@spindle.srvr.nix>
 <20100906053255.GA23340@brouette>
 <87iq2gyllg.fsf@spindle.srvr.nix>
 <87wrqu8s1u.fsf_-_@spindle.srvr.nix>
 <4C8982EF.8030705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C8982EF.8030705@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 09/10/10 00:34, Nix wrote:
> > It did: I found a system on which the fault was consistently
> > reproducible. Bisected.

Thanks for doing this! Nice work!

* Artur Skawina <art.08.09@gmail.com> [2010-09-10 02:59]:
> I'm seeing this too, except here it happens every couple of days of uptime,
> lasts for a few minutes, and then goes away. Which made bisecting a bit
> impractical... Thank you for doing it. 
> HW is similar; x64 and X58/82801JI/ICH10, tsc clocksrc.
> Did that printk trigger? Empirically confirming that this is the problem
> could take weeks here, as it happens so rarely...

Same here, I have not yet seen the problem with 2.6.35.4 and a max
uptime of 3 or 4 days.

My details are identical: tsc clocksource, x86-64 and X58/82801JI/ICH10.

-- 
Damien
