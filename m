Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab0IQSim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 14:38:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20219 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab0IQSik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 14:38:40 -0400
Message-ID: <4C93B561.2040902@kernel.org>
Date: Fri, 17 Sep 2010 11:37:21 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Lin Ming <ming.m.lin@intel.com>,
        Bob Moore <robert.moore@intel.com>
Subject: Re: [PATCH] acpi: handle ACPI0007 Device in acpi_early_set_pdc
References: <4C89906B.1050406@kernel.org> <201009131128.42519.bjorn.helgaas@hp.com> <4C931714.2080905@kernel.org> <201009170756.53100.bjorn.helgaas@hp.com>
In-Reply-To: <201009170756.53100.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2010 06:56 AM, Bjorn Helgaas wrote:
> On Friday, September 17, 2010 01:21:56 am Yinghai Lu wrote:
>> On 09/13/2010 10:28 AM, Bjorn Helgaas wrote:
>>> On Friday, September 10, 2010 08:06:26 pm Yinghai Lu wrote:
>>>
>>> I timed the original on a 64-CPU box where the namespace walk cost
>>> should be relatively high, and the walk you added takes about 0.01
>>> seconds.  The one already there took about 0.03 seconds, so neither
>>> costs very much.
>>>
>>> And I don't like the fact that the patch below changes the ACPI CA
>>> and it only partly implements acpi_get_devices(), since it ignores
>>> _CID and _STA.
>>
>> please check this one. it still keep _STA etc.
> 
> I think you missed this line in my previous response:
> 
>>> But I do see your point, and having seen the patch
>>> below, I prefer the original one-line version.
> 
> The patch below is better, because it doesn't reimplement quite
> so much stuff, but it still changes the CA,
not sure.
> and I think the end
> result is still quite confusing to read.
yeah, it is confusing to read.... callback with callback.
> 
> So I still prefer the original one-line version.

ok, Will resend out original one with updated changelog.

Yinghai
