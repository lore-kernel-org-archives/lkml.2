Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934537Ab0HFUNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 16:13:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754724Ab0HFUM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 16:12:57 -0400
MIME-Version: 1.0
In-Reply-To: <201008062158.46013.arnd@arndb.de>
References: <20100805213528.GA13794@kroah.com> <20100806204552.7cb80fd0@lxorguk.ukuu.org.uk> 
	<AANLkTimGoG97dtp_hmHBJwwo1stzZxLoKs4_jr+eQ=gJ@mail.gmail.com> 
	<201008062158.46013.arnd@arndb.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Aug 2010 13:11:46 -0700
Message-ID: <AANLkTi=Yv2TE1x6aT2GLC9+CKQXaeDJciAMEfNa1_XXx@mail.gmail.com>
Subject: Re: [GIT PATCH] TTY patches for 2.6.36
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 6, 2010 at 12:58 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> If you apply this version, the only stronghold left for the BKL
> will be fs/lockd, everything else that's left is either simple
> to fix or highly obscure.

Didn't we have patches for fs/lockd/ too? Or am I just confused with
the fs/locks.c patches?

        Linus
