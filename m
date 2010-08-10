Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab0HJWry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:47:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830Ab0HJWrw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:47:52 -0400
MIME-Version: 1.0
In-Reply-To: <19552.39399.490494.51990@notabene.brown>
References: <19552.39399.490494.51990@notabene.brown>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Aug 2010 15:47:21 -0700
Message-ID: <AANLkTinbCHAB3tPos1sp078maWaHAQbRM8oWMOiF1U8D@mail.gmail.com>
Subject: Re: [REVISED PULL REQUEST] md updates for 2.6.36
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 9, 2010 at 5:14 PM, Neil Brown <neilb@suse.de> wrote:
>
>  create mode 100644 lib/raid6/Makefile
>  rename {drivers/md => lib/raid6}/mktables.c (100%)
>  rename {drivers/md => lib/raid6}/raid6algos.c (100%)
>  rename {drivers/md => lib/raid6}/raid6altivec.uc (100%)
>  rename {drivers/md => lib/raid6}/raid6int.uc (100%)
>  rename {drivers/md => lib/raid6}/raid6mmx.c (100%)
>  rename {drivers/md => lib/raid6}/raid6recov.c (100%)
>  rename {drivers/md => lib/raid6}/raid6sse1.c (100%)
>  rename {drivers/md => lib/raid6}/raid6sse2.c (100%)
>  rename {drivers/md => lib/raid6}/raid6test/Makefile (100%)
>  rename {drivers/md => lib/raid6}/raid6test/test.c (100%)
>  rename {drivers/md => lib/raid6}/raid6x86.h (100%)
>  rename {drivers/md => lib/raid6}/unroll.awk (100%)

Hmm. Why "lib/raid6/raid6sse2.c" and friends? Why "raid6" twice? You
don't mean "raid6+1" (mirrored raid6 ;), so why not just remove the
second "raid6", and call it "lib/raid6/sse2.c"

But I pulled. Just in case there was some logic to the duplication.

                               Linus
