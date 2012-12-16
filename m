Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab2LPKes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 05:34:48 -0500
Received: from home.kolivas.org ([59.167.196.135]:48399 "EHLO mine.kolivas.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752330Ab2LPKer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 05:34:47 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] 3.7-ck1, BFS 426 for linux-3.7
Date: Sun, 16 Dec 2012 21:34:44 +1100
Message-ID: <3073864.TyVduqceRg@hex>
User-Agent: KMail/4.9.4 (Linux/3.7.0-ck1; KDE/4.9.4; x86_64; ; )
In-Reply-To: <CAJd=RBBo2hXsqgz=TbV7CBKsL_W1BNxAESA4OKPqRtQzyiL=uA@mail.gmail.com>
References: <7369728.ymAnBsBeai@hex> <1911613.U2Pnzoqhvo@hex> <CAJd=RBBo2hXsqgz=TbV7CBKsL_W1BNxAESA4OKPqRtQzyiL=uA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Dec 2012 18:33:14 Hillf Danton wrote:
> On Sun, Dec 16, 2012 at 5:54 PM, Con Kolivas <kernel@kolivas.org> wrote:
> > On Sun, 16 Dec 2012 11:16:31 Con Kolivas wrote:
> >> These are patches designed to improve system responsiveness and
> >> interactivity with specific emphasis on the desktop, but suitable to
> >> any commodity hardware workload.
> >> 
> >> Apply to 3.7.x:
> >> -ck-ckhttp://ck.kolivas.org/patches/3.0/3.7/3.71/patch-3.71.bz2
> >> or
> >> -ck-ckhttp://ck.kolivas.org/patches/3.0/3.7/3.71/patch-3.71.lrz
> >> 
> >> Broken out tarball:
> >> -ck-ckhttp://ck.kolivas.org/patches/3.0/3.7/3.71/3.71-broken-out.tar.bz2
> >> or
> >> -ck-ckhttp://ck.kolivas.org/patches/3.0/3.7/3.71/3.71-broken-out.tar.lrz
> >> 
> >> Discrete patches:
> >> -ckhttp://ck.kolivas.org/patches/3.0/3.7/3.71/patches/
> >> 
> >> Latest BFS by itself:
> >> http://ck.kolivas.org/patches/bfs/3.0/3.7/3.7-sched-bfs-426.patch
> >> 
> >> Web:
> >> http://kernel.kolivas.org
> >> 
> >> Code blog when I feel like it:
> >> http://ck-hack.blogspot.com/
> > 
> > Of course these links all got scrambled somehow, but I'm sure you can
> > figure out where the patches are :p
> 
> Better if changes after 425 are directly attached?
> 
> Hillf

That's of not much use without all the merging changes as well. The 425 patch 
for mainline 3.7 looks nothing like the 425 patch for 3.6. see my blog for 
details.

Con
-- 
-ck
