Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192Ab1IUV0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:26:53 -0400
Received: from nef2.ens.fr ([129.199.96.40]:3610 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab1IUV0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:26:52 -0400
X-Greylist: delayed 2223 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Sep 2011 17:26:52 EDT
Date: Wed, 21 Sep 2011 22:49:46 +0200
From: =?iso-8859-1?Q?=C9ric?= Brunet <Eric.Brunet@lps.ens.fr>
To: linux-kernel@vger.kernel.org
Subject: Re: Regression between 2.6.35 and 2.6.38 (freeze at resume)
Message-ID: <20110921204946.GA4304@lps.ens.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Wed, 21 Sep 2011 22:49:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In-Reply-To: <s5hy5xigjts.wl%tiwai@suse.de>
References: <201109170935.17777.Eric.Brunet@lps.ens.fr> <201109202206.35705.Eric.Brunet@lps.ens.fr> <s5hy5xigjts.wl%tiwai@suse.de>

>> I'd like to know what I can do to help nail this annoying bug. I am
>> not sure if I can git bisect it; it is hard to tell offhand if a
>> kernel is good; it may resume correctly many times before crashing.
>
> Did you try the recent 3.1-rc?  There have been a few commits relevant
> with battery module and PM after 3.0, and I guess this will be the fix
> for your case, too.

I did try 3.0.4 and it crashed the same way. I'll try 3.1-rc as you
suggest.

The point is that it worked very well in F14 with 2.6.35 kernels. I was
trying to find out in which kernel exactly the problems began. I couldn't
crash 2.6.36, 2.6.37 and 2.6.38 but, today, 2.6.39-rc1 crashed on me. I
suspect (because there is a small change of behaviour) that the problem
appears in 2.6.38 even though I haven't crashed it yet. Were there some
changes in battery and PM around 2.6.38 ?

Anyway, I start now to compile 3.1.

Thanks,

        Éric Brunet
