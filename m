Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab1ERUzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:55:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133Ab1ERUzG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:55:06 -0400
MIME-Version: 1.0
In-Reply-To: <tip-26afb7c661080ae3f1f13ddf7f0c58c4f931c22b@git.kernel.org>
References: <1305210630-7136-1-git-send-email-jolsa@redhat.com> <tip-26afb7c661080ae3f1f13ddf7f0c58c4f931c22b@git.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 May 2011 13:54:09 -0700
Message-ID: <BANLkTimoHTmSa4LwpN-FLiEwWVLfBetV8g@mail.gmail.com>
Subject: Re: [tip:perf/core] x86, 64-bit: Fix copy_[to/from]_user() checks for
 the userspace address limit
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, torvalds@linux-foundation.org, jolsa@redhat.com,
        stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 1:43 PM, tip-bot for Jiri Olsa <jolsa@redhat.com> wrote:
> As reported in BZ #30352:
>
>  https://bugzilla.kernel.org/show_bug.cgi?id=30352
>
> there's a kernel bug related to reading the last allowed page on x86_64.

Btw, I think this message is very misleading.

It has nothing what-so-ever to do with "the last allowed page".

It is not about pages at all. It's about bytes. It's the very last
byte of the address space. The fact that the *test*program* uses mmap
and then sends a single page is totally irrelevant both for the kernel
and for the patch itself.

                      Linus
