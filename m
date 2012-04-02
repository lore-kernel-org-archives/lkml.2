Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab2DBQQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 12:16:30 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64627 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab2DBQQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 12:16:29 -0400
MIME-Version: 1.0
In-Reply-To: <1333380769-2650-1-git-send-email-consul.kautuk@gmail.com>
References: <1333380769-2650-1-git-send-email-consul.kautuk@gmail.com>
Date: Mon, 2 Apr 2012 09:16:28 -0700
Message-ID: <CAF8ieYUyiRj45O+zu399yL_biE6fm-q8W-qjaxTHNS4ci3otBA@mail.gmail.com>
Subject: Re: [PATCH 01/19 v2.1] avr32/mm/fault.c: Port OOM changes to do_page_fault
From: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel@vger.kernel.org, "Mohd. Faris" <mohdfarisq2010@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 2, 2012 at 8:32 AM, Kautuk Consul <consul.kautuk@gmail.com> wrote:
> Commit d065bd810b6deb67d4897a14bfe21f8eb526ba99
> (mm: retry page fault when blocking on disk transfer) and
> commit 37b23e0525d393d48a7d59f870b3bc061a30ccdb
> (x86,mm: make pagefault killable)
>
> The above commits introduced changes into the x86 pagefault handler
> for making the page fault handler retryable as well as killable.
>
> These changes reduce the mmap_sem hold time, which is crucial
> during OOM killer invocation.
>
> Port these changes to AVR32.
>
> Signed-off-by: Mohd. Faris <mohdfarisq2010@gmail.com>
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>

Acked-by: Havard Skinnemoen <hskinnemoen@gmail.com>
