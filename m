Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab1BPW5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:57:17 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:18247 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab1BPW5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:57:14 -0500
Message-ID: <4D5C55DD.3050206@kernel.org>
Date: Wed, 16 Feb 2011 14:55:25 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, numa: cleanup x86_acpi_numa_init()
References: <4D5C3A0F.3080107@kernel.org> <4D5C5046.1030903@kernel.org> <20110216224922.GD29600@atj.dyndns.org>
In-Reply-To: <20110216224922.GD29600@atj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D5C563C.007B,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2011 02:49 PM, Tejun Heo wrote:
> On Wed, Feb 16, 2011 at 02:31:34PM -0800, Yinghai Lu wrote:
>> make it more readable. put valid checking together.
>>
>> Also restore old acpi_numa_init(). we don't need to touch it
>> because already have x86 own wrapper.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> What's the point of this patch?  If someone else likes it, I don't
> object but I have no idea why this is any better than before.

before you added x86_acpi_numa_init(), you modified acpi_numa_init...

you really don't need to touch other acpi code, if we can limit that in x86 code.

Yinghai
