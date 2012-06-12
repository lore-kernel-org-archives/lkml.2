Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab2FLQLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:11:50 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:47485 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2FLQLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:11:49 -0400
Date: Tue, 12 Jun 2012 18:11:45 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: =?iso-8859-1?Q?H=E5vard?= Skinnemoen <hskinnemoen@gmail.com>,
        linux-kernel@vger.kernel.org, "Mohd. Faris" <mohdfarisq2010@gmail.com>
Subject: Re: [PATCH 01/19 v2.1] avr32/mm/fault.c: Port OOM changes to
 do_page_fault
Message-ID: <20120612161145.GA10959@samfundet.no>
References: <1333380769-2650-1-git-send-email-consul.kautuk@gmail.com>
 <CAF8ieYUyiRj45O+zu399yL_biE6fm-q8W-qjaxTHNS4ci3otBA@mail.gmail.com>
 <CAFPAmTT4tHkLM1ig8GRM4O8vMmXPO2o4cCE=2abqd0e+B+CkTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFPAmTT4tHkLM1ig8GRM4O8vMmXPO2o4cCE=2abqd0e+B+CkTQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Tue 12 Jun 2012 21:27:03 +0530 or thereabout, Kautuk Consul wrote:

Hello,

> When can I see this patch in linux-next ?
> 

Currently there are no AVR32 git tree, since I don't have a kernel.org
account. I hope to meet somebody with a signed key, but until I do, could you
run the patch by Andrew?

> On Mon, Apr 2, 2012 at 9:46 PM, Håvard Skinnemoen <hskinnemoen@gmail.com> wrote:
>> On Mon, Apr 2, 2012 at 8:32 AM, Kautuk Consul <consul.kautuk@gmail.com> wrote:
>>> Commit d065bd810b6deb67d4897a14bfe21f8eb526ba99
>>> (mm: retry page fault when blocking on disk transfer) and
>>> commit 37b23e0525d393d48a7d59f870b3bc061a30ccdb
>>> (x86,mm: make pagefault killable)
>>>
>>> The above commits introduced changes into the x86 pagefault handler
>>> for making the page fault handler retryable as well as killable.
>>>
>>> These changes reduce the mmap_sem hold time, which is crucial
>>> during OOM killer invocation.
>>>
>>> Port these changes to AVR32.
>>>
>>> Signed-off-by: Mohd. Faris <mohdfarisq2010@gmail.com>
>>> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
>>
>> Acked-by: Havard Skinnemoen <hskinnemoen@gmail.com>

-- 
mvh
Hans-Christian Egtvedt
