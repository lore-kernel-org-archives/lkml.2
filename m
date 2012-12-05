Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab2LEP4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 10:56:53 -0500
Received: from smtpout21.ngs.ru ([195.19.71.4]:38594 "EHLO smtpout.ngs.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab2LEP4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 10:56:53 -0500
Message-ID: <50BF6DF1.4080802@eml.ru>
Date: Wed, 05 Dec 2012 22:53:21 +0700
From: Bokhan Artem <art@eml.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/15.0 Thunderbird/15.0a1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at /build/buildd/linux-2.6.32/mm/mempolicy.c
References: <50BF66A0.1050503@eml.ru> <20121205155357.GB12119@liondog.tnic>
In-Reply-To: <20121205155357.GB12119@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.12.2012 22:53, Borislav Petkov wrote:
> On Wed, Dec 05, 2012 at 10:22:08PM +0700, Bokhan Artem wrote:
>> Hello.
>>
>> We have several servers with mongodb running. Each server has
>> several mongodb instances. Mongodb dataset is larger then availiable
>> memory (mongodb uses memory-mapped files for all disk I/O).
>> 2.6.32 and 2.6.38 kernels periodically crash and crash happens only
>> with mongodb servers.
>>
>> 2.6.38's trace is in attachment.
>> For 2.6.32 I only have "kernel BUG at
>> /build/buildd/linux-2.6.32/mm/mempolicy.c:1489!"
> Can you reproduce this with the current upstream kernel 3.7-rc8? If no,
> then you should complain to the ubuntu people or whoever provides your
> kernels.
>

We will try.
