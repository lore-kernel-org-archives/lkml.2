Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409Ab2FAOtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:49:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60940 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933368Ab2FAOtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:49:01 -0400
Message-ID: <4FC8D658.1040004@gmail.com>
Date: Fri, 01 Jun 2012 08:48:56 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH] perf tool: build fix, remove duplicate declarations
References: <1338352913-60483-1-git-send-email-dsahern@gmail.com> <4FC851AB.2090905@gmail.com> <20120601135058.GC16429@infradead.org>
In-Reply-To: <20120601135058.GC16429@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/1/12 7:50 AM, Arnaldo Carvalho de Melo wrote:
> Strange, I just tested on f14 x86_64 and i386, in addition to RHEL6.2,
> no problems :-\

Very strange. I thought I had chased away all of the local gremlins, but 
a freshly created and fully updated F16-32bit VM and an older F14-64-bit 
are both hitting this.

>
>> idea why I am suddenly hitting it on F14 and F16 (my usual test
>> servers; i have always hit this on older systems), but nonetheless
>> there are duplicate declarations between util.h and symbol.h which
>> should be fixed.
>
> Yeah, but the patch is not applying on my perf/urgent branch, can you
> take a look?

the recent byteswap include. I'll re-spin.

David
