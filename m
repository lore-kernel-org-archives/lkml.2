Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab1KAGhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 02:37:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42915 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab1KAGhp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 02:37:45 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1110311552280.22237@chino.kir.corp.google.com>
References: <1319811801-1725-1-git-send-email-penberg@kernel.org>
	<1319811801-1725-3-git-send-email-penberg@kernel.org>
	<alpine.DEB.2.00.1110311552280.22237@chino.kir.corp.google.com>
Date: Tue, 1 Nov 2011 08:37:44 +0200
X-Google-Sender-Auth: OYCplcsKY1dAycqb8-3-Bh4STbY
Message-ID: <CAOJsxLGk-0ev6KVfX2-F9dQUAYPJyE0-OVLQnEiAxi_inTUZqw@mail.gmail.com>
Subject: Re: [RFC/PATCH 3/7] x86, mm: Use max_pfn instead of highend_pfn
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 1, 2011 at 12:54 AM, David Rientjes <rientjes@google.com> wrote:
>> @@ -54,7 +54,7 @@
>>  #include <asm/page_types.h>
>>  #include <asm/init.h>
>>
>> -unsigned long highstart_pfn, highend_pfn;
>> +unsigned long highstart_pfn;
>>
>>  static noinline int do_test_wp_bit(void);
>>
>
> This shouldn't build with a CONFIG_NUMA i386 config, highend_pfn is used
> in arch/x86/mm/numa_32.c.

Fixed, thanks!
