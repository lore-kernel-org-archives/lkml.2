Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab2FLP5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:57:07 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37406 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab2FLP5E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:57:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAF8ieYUyiRj45O+zu399yL_biE6fm-q8W-qjaxTHNS4ci3otBA@mail.gmail.com>
References: <1333380769-2650-1-git-send-email-consul.kautuk@gmail.com>
	<CAF8ieYUyiRj45O+zu399yL_biE6fm-q8W-qjaxTHNS4ci3otBA@mail.gmail.com>
Date: Tue, 12 Jun 2012 21:27:03 +0530
Message-ID: <CAFPAmTT4tHkLM1ig8GRM4O8vMmXPO2o4cCE=2abqd0e+B+CkTQ@mail.gmail.com>
Subject: Re: [PATCH 01/19 v2.1] avr32/mm/fault.c: Port OOM changes to do_page_fault
From: Kautuk Consul <consul.kautuk@gmail.com>
To: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel@vger.kernel.org, "Mohd. Faris" <mohdfarisq2010@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

When can I see this patch in linux-next ?

Thanks,
Kautuk.

On Mon, Apr 2, 2012 at 9:46 PM, Håvard Skinnemoen <hskinnemoen@gmail.com> wrote:
> On Mon, Apr 2, 2012 at 8:32 AM, Kautuk Consul <consul.kautuk@gmail.com> wrote:
>> Commit d065bd810b6deb67d4897a14bfe21f8eb526ba99
>> (mm: retry page fault when blocking on disk transfer) and
>> commit 37b23e0525d393d48a7d59f870b3bc061a30ccdb
>> (x86,mm: make pagefault killable)
>>
>> The above commits introduced changes into the x86 pagefault handler
>> for making the page fault handler retryable as well as killable.
>>
>> These changes reduce the mmap_sem hold time, which is crucial
>> during OOM killer invocation.
>>
>> Port these changes to AVR32.
>>
>> Signed-off-by: Mohd. Faris <mohdfarisq2010@gmail.com>
>> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
>
> Acked-by: Havard Skinnemoen <hskinnemoen@gmail.com>
