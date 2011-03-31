Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab1CaQRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:17:09 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49987 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab1CaQRH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:17:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oCCkeyooUg+U5NhsJq1n2iVIQRtAym00HmHkJ64gX0rilHICgYvjcoQmDKRWfrUoEn
         BrRfIX9WXpbDezwcHxKRucVykS6LRztIcwoZ5sIpBdIDGO09YIN9uXm1WDH5PzH2iPF8
         MuUWzDFR5YnGI538UuEQSQr1qwTHqhKHXTkA0=
MIME-Version: 1.0
In-Reply-To: <4D949C87.1000001@sgi.com>
References: <20110225180633.857892225@gulag1.americas.sgi.com>
	<20110225180634.017570095@gulag1.americas.sgi.com>
	<20110227120949.GF16453@elte.hu>
	<20110227121518.GA19165@elte.hu>
	<4D6AFBB0.70401@kernel.org>
	<4D6BF63D.2020404@sgi.com>
	<AANLkTi=Sn6DKAjGHQjtWGiLGh8vpuS-vmXK=TMDrbjdv@mail.gmail.com>
	<4D6BFF46.3050001@sgi.com>
	<AANLkTi=Xf5RaF559QsRNijmG0YP7amkG569NZFhpt4QY@mail.gmail.com>
	<4D93CDD7.8000708@sgi.com>
	<AANLkTi=eRgp0wqpwq-W=E7ptrnQuM837+J+enEA2wey-@mail.gmail.com>
	<4D949C87.1000001@sgi.com>
Date: Thu, 31 Mar 2011 09:17:05 -0700
X-Google-Sender-Auth: 3eCw6KoNMXT2t_h1jrFI5W8yjH8
Message-ID: <AANLkTikCEnWjgqSaXnMWTEhzqK9h9Sra5_XRkAQwjZrd@mail.gmail.com>
Subject: Re: [PATCH 1/2] memblock: add error return when CONFIG_HAVE_MEMBLOCK
 is not set
From: Yinghai Lu <yinghai@kernel.org>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Rientjes <rientjes@google.com>,
        Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 8:23 AM, Mike Travis <travis@sgi.com> wrote:
>
>>
>> setup_log_buf will pass function pointer, So this one is not needed,
>> right?
>
> The other function would need the #ifdef CONFIG_HAVE_MEMBLOCK before calling
> memblock_alloc which I thought was the point of this patch?  Note we still
> have the last fallback of using alloc_boot_mem in kernel/init.c.

before that patch, it already use bootmem allocation.

So should be ok to drop this one.

Thanks

Yinghai
