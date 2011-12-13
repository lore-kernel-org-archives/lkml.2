Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab1LMJZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 04:25:41 -0500
Received: from mail.klingt.org ([86.59.21.178]:35686 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab1LMJZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 04:25:35 -0500
From: Tim Blechmann <tim@klingt.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, torvalds@linux-foundation.org,
        x86@kernel.org
Subject: Re: [PATCH] x86: Split off mem*io functions
Date: Tue, 13 Dec 2011 10:23:09 +0100
Message-ID: <3289381.F4yDCuQyhd@moka>
User-Agent: KMail/4.7.3 (Linux/3.2.0-rc4+; KDE/4.7.3; x86_64; ; )
In-Reply-To: <CAMzpN2izpSgT1D4XQ_unkg4dvZCuTioPx1n98mrui50Ta+txMQ@mail.gmail.com>
References: <CAMzpN2jiZn3=Og9EVhnWbEhZkvi6eebEJpR7qYn00OyJnZgcFQ@mail.gmail.com> <1323641436-12249-1-git-send-email-brgerst@gmail.com> <CAMzpN2izpSgT1D4XQ_unkg4dvZCuTioPx1n98mrui50Ta+txMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (klingt.org [86.59.21.178]); Tue, 13 Dec 2011 10:23:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Commit 6175ddf06b6172046a329e3abfd9c901a43efd2e changed the mem*io
> > functions to use the standard memcpy/memset routines, but there were
> > unintended consequences.  Some devices cannot cope with 64-bit or
> > non-sequential accesses that the optimized routines do.  Change them
> > back to simple 32-bit sequential writes.
> 
> Tim, please test the lx6464es driver with this patch and commit
> a2987855 reverted.

unfortunately, it will take some time before i will be able to access the 
machine with the lx6464es device. will report back, when i've tested your 
patch, but it might take a few weeks ...

tim

