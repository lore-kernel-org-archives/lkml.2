Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab1DDPLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 11:11:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48846 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269Ab1DDPLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:11:47 -0400
Date: Mon, 4 Apr 2011 17:11:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        "lkml20101129@newton.leun.net" <lkml20101129@newton.leun.net>,
        stable kernel team <stable@kernel.org>
Subject: Re: [PATCH urgent] x86: Save cr4 to mmu_cr4_features at boot time
Message-ID: <20110404151132.GC11475@elte.hu>
References: <alpine.DEB.2.00.1103311715400.16492@kaball-desktop>
 <20110401062338.GA6434@elte.hu>
 <alpine.DEB.2.00.1104011212070.16492@kaball-desktop>
 <20110401190812.GA16830@elte.hu>
 <alpine.DEB.2.00.1104012318390.16492@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104012318390.16492@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:

> Just to clarify the situation the patch "x86-64: finish cleanup_highmaps()'s 
> job wrt. _brk_end" was backported to the stable trees [...]

There's no commit with such a title upstream - there's not even one that is 
close. Could you cite the sha1 you refer to?

> [...] (including Jeremy's 2.6.32 xen tree because he pulled from 2.6.32.y) 
> breaking boot on xen.

Basing upstream-relevant trees on stable backported sha1's is a very, very bad 
idea.

> Yinghai's patch plus another patch of mine fix that breakage and that is why 
> I ask for it to be backported.

So it fixes a commit that is nowhere to be found upstream?

> I didn't mean for the backport to be done right now, I just wanted to
> notify the stable maintainers that the particular commit should be
> backported at some point.
> 
> I didn't mean to overstep your authority in any way.

It's not about overstepping authority - it's about not breaking the native 
kernel on millions of boxes.

Thanks,

	Ingo
