Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762010Ab0HFUUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 16:20:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57318 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab0HFUUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 16:20:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PATCH] TTY patches for 2.6.36
Date: Fri, 6 Aug 2010 22:19:19 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.4.92; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <20100805213528.GA13794@kroah.com> <201008062158.46013.arnd@arndb.de> <AANLkTi=Yv2TE1x6aT2GLC9+CKQXaeDJciAMEfNa1_XXx@mail.gmail.com>
In-Reply-To: <AANLkTi=Yv2TE1x6aT2GLC9+CKQXaeDJciAMEfNa1_XXx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008062219.19442.arnd@arndb.de>
X-Provags-ID: V02:K0:4for5rr2X7IXa6hAs7g6/e3jKCmkFU6PoQV2HMfj1K+
 djmRvf47Gb5G1ohA72gh896Z2OXUQDcRgFHYkeFDuFX/U545AZ
 uNhL3wK+QITLtr7LwkGPUWf1l01Kue+zHgZ6bF7VsmW5APmx0t
 y4FfvM4ZO2GNgmzCCwUSv+nxt2xZIp6RWe1a1etAHyulo7IZRM
 v22FPlZTCtJm+dcsDJjig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 August 2010 22:11:46 Linus Torvalds wrote:
> On Fri, Aug 6, 2010 at 12:58 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > If you apply this version, the only stronghold left for the BKL
> > will be fs/lockd, everything else that's left is either simple
> > to fix or highly obscure.
> 
> Didn't we have patches for fs/lockd/ too? Or am I just confused with
> the fs/locks.c patches?

I had a ten-year old patch from Willy that takes care of fs/locks.c,
but we can't apply that without also taking care of fs/lockd.

I first didn't realize this when I sent that patch.

	Arnd
