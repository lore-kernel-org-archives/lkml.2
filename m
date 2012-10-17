Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab2JQJTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 05:19:14 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:53112 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454Ab2JQJTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 05:19:12 -0400
MIME-Version: 1.0
In-Reply-To: <507E75AA.2000605@cn.fujitsu.com>
References: <506C0AE8.40702@jp.fujitsu.com> <506C0C53.60205@jp.fujitsu.com>
 <CAHGf_=p7PaQs-kpnyB8uC1MntHQfL-CXhhq4QQP54mYiqOswqQ@mail.gmail.com>
 <50727984.20401@cn.fujitsu.com> <CAHGf_=pCrx8AkL9eiSYVgwvT1v0SW2__P_DW-1Wwj_zskqcLXw@mail.gmail.com>
 <507E54AA.2080806@cn.fujitsu.com> <CAHGf_=o_Wu1kr56C=7XTjYRzL4egSyGJYd4+2RecVWzpeM427Q@mail.gmail.com>
 <507E75AA.2000605@cn.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 17 Oct 2012 05:18:51 -0400
X-Google-Sender-Auth: xPFFFX1TLUKM8j8wP-UnfcN2tbI
Message-ID: <CAHGf_=oNufcAQhxWtvq56qwF==+14+Cm7r9eiTGdY=B=ENwPQg@mail.gmail.com>
Subject: Re: [PATCH 1/4] acpi,memory-hotplug : add memory offline code to acpi_memory_device_remove()
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> Hmm, it doesn't move the code. It just reuse the code in acpi_memory_powerdown_device().
>>>>
>>>> Even if reuse or not reuse, you changed the behavior. If any changes
>>>> has no good rational, you cannot get an ack.
>>>
>>> I don't understand this? IIRC, the behavior isn't changed.
>>
>> Heh, please explain why do you think so.
>
> We just introduce a function, and move codes from acpi_memory_disable_device() to the new
> function. We call the new function in acpi_memory_disable_device(), so the function
> acpi_memory_disable_device()'s behavior isn't changed.
>
> Maybe I don't understand what do you want to say.

Ok, now you agreed you moved the code, yes? So then, you should explain why
your code moving makes zero impact other acpi_memory_disable_device() caller.
