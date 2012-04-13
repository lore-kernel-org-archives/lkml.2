Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab2DMOYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 10:24:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57596 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab2DMOYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 10:24:40 -0400
Message-ID: <4F88371D.7030305@gmail.com>
Date: Fri, 13 Apr 2012 22:24:29 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: shuahkhan@gmail.com
CC: Toshi Kani <toshi.kani@hp.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] ACPI: Add _OST support for ACPI hotplug
References: <1334096510-17319-1-git-send-email-toshi.kani@hp.com>  <1334161991.2226.18.camel@lorien2>  <1334170247.20190.34.camel@misato.fc.hp.com> <1334240353.2222.3.camel@lorien2>
In-Reply-To: <1334240353.2222.3.camel@lorien2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah and Toshi,
	As I can tell, _OST method has been defined in ACPI4.0 spec and
there are some platforms already implemented the _OST method. For example,
Quanta QSSC-S4R server implements _OST for hot-pluggable PCI slots, but 
it's a little pity that it doesn't implement _OST for the memory board,
so we can't test Toshi's patch on that platform.
	According to my understanding, other than notifying BIOS about the
event processing result, _OST could also be used to notify BIOS about the
IN_PROGRESS state, so BIOS could track the event handling progress and avoid
timeout. We have used _OST method to avoid timeout on one of our prototype
platforms.

On 04/12/2012 10:19 PM, Shuah Khan wrote:
> 
>> Hi Shuah,
>>
>> The fake _OST methods print arguments to verify successful execution of
>> the methods.  Since the purpose of _OST is firmware-internal
>> communication, there is no difference in testing on real firmware from
>> the OS perspective.  Overriding DSDT with fake ACPI methods is a
>> well-established and widely used testing method as well.
> 
> Toshi,
> 
> This patch hasn't gone through sufficient new functionality testing as
> the only testing that was done was exercising it with stubbed out
> firmware calls. I am not clear on how much regression testing this patch
> has undergone. Sorry, it doesn't give me the warm and fuzzies.
> 
> -- Shuah
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

