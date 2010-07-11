Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab0GKIjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 04:39:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55720 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab0GKIjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 04:39:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=o/4pjuoijAncc/qDI3nAc74Xwud8gFIn/CFtGQWhP88BPJaEe8Zd5eyD2rFdXVI81Y
         nFnMAKVgaaiF2J4cAMr2h9r09dGQUImlMP9L7EbGpZ5m0dN6jdW+AKXrUxPv8BPWE2SV
         ilcocH451GWD8z0/IZfyUQU67cS3+yx87MrcM=
Subject: Re: stable? quality assurance?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <201007110918.42120.Martin@lichtvoll.de>
References: <201007110918.42120.Martin@lichtvoll.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Jul 2010 10:39:44 +0200
Message-ID: <1278837584.2538.135.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 11 juillet 2010 à 09:18 +0200, Martin Steigerwald a écrit :
> Hi!
> 
> 2.6.34 was a desaster for me: bug #15969 - patch was availble before 
> 2.6.34 already, bug #15788, also reported with 2.6.34-rc2 already, as well 
> as most important two complete lockups - well maybe just X.org and radeon 
> KMS, I didn't start my second laptop to SSH into the locked up one - on my 
> ThinkPad T42. I fixed the first one with the patch, but after the lockups I 
> just downgraded to 2.6.33 again.
> 
> I still actually *use* my machines for something else than hunting patches 
> for kernel bugs and on kernel.org it is written "Latest *Stable* Kernel" 
> (accentuation from me). I know of the argument that one should use a 
> distro kernel for machines that are for production use. But frankly, does 
> that justify to deliver in advance known crap to the distributors? What 
> impact do partly grave bugs reported on bugzilla have on the release 
> decision?
> 
> And how about people who have their reasons - mine is TuxOnIce - to 
> compile their own kernels?
> 
> Well 2.6.34.1 fixed the two reported bugs and it seemed to have fixed the 
> freezes as well. So far so good.
> 
> Maybe it should read "prerelease of stable" for at least 2.6.34.0 on the 
> website. And I just again always wait for .2 or .3, as with 2.6.34.1 I 
> still have some problems like the hang on hibernation reported in
> 
> hang on hibernation with kernel 2.6.34.1 and TuxOnIce 3.1.1.1
> 
> on this mailing list just a moment ago. But then 2.6.33 did hang with 
> TuxOnIce which apparently (!) wasn't a TuxOnIce problem either, since 
> 2.6.34 did not hang with it anymore which was a reason for me to try 
> 2.6.34 earlier.
> 
> I am quite a bit worried about the quality of the recent kernels. Some 
> iterations earlier I just compiled them, partly even rc-ones which I do 
> not expact to be table, and they just worked. But in the recent times .0, 
> partly even .1 or .2 versions haven't been stable for me quite some times 
> already and thus they better not be advertised as such on kernel.org I 
> think. I am willing to risk some testing and do bug reports, but these are 
> still production machines, I do not have any spare test machines, and 
> there needs to be some balance, i.e. the kernels should basically work. 
> Thus I for sure will be more reluctant to upgrade in the future.
> 
> Ciao,

Anybody running latest kernel on a production machine is living
dangerously. Dont you already know that ?

When 2.6.X is released, everybody knows it contains at least 100 bugs.

It was true for all previous values of X, it will be true for all
futures values.

If you want to be safer, use a one year old kernel, with all stable
patches in.

Something like 2.6.32.16 : Its probably more stable than all 2.6.X
kernels.

If 2.6.33 runs OK on your machine, you are lucky, since 2.6.33.6
contains numerous bug fixes.


