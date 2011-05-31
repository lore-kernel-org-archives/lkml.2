Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab1EaNYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:24:09 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:43664 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab1EaNYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:24:05 -0400
Message-ID: <4DE4EBE0.7050007@linux.vnet.ibm.com>
Date: Tue, 31 May 2011 10:23:44 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
CC: debora@linux.vnet.ibm.com, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        jirislaby@gmail.com, preining@logic.at
Subject: Re: [PATCH V2 00/12] tpm + tpm_tis : Various fixes
References: <20110330161322.015113054@linux.vnet.ibm.com> <4DE00FDC.309@linux.vnet.ibm.com>
In-Reply-To: <4DE00FDC.309@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11053113-8936-0000-0000-00000342FE29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

Yes, I'll have them reviewed again and in a git pull request real soon.

Thanks, Rajiv Andrade
Security Development
IBM Linux Technology Center

On 05/27/2011 05:55 PM, Stefan Berger wrote:
> Rajiv,
>
>   are you planning to use these patches?
>
> Regards,
>    Stefan
>
>
> On 03/30/2011 12:13 PM, Stefan Berger wrote:
>> This patchset fixes various issues in the general TPM driver and the TPM TIS
>> driver. Some of the patches were previously posted, and are being re-posted
>> without change, while other patches were refactored. This patchset applies to
>> the tip of the main git tree.
>>
>> Patches 1-6 are related to using the timeouts that the TPM reports, along with
>> work-arounds for TPMs that don't report the timeouts in microseconds but
>> rather in milliseconds.
>>
>> Patch 7 fixes the display of the public key of the TPM's Endorsement Key in
>> sysfs.
>>
>> Patch 8 re-enables the TPM's interrupts after resume from S3.
>>
>> Patch 9 is useful if the TPM is run in interrupt mode and delays the S3 suspend
>> until the TPM has finished processing a command.
>>
>> Patch 10 fixes several aspects of the code around the probing for interrupts.
>>
>> Patch 11 introduces automatic probing for the Intel iTPM flaw. The probing
>> is useful in combination with the 'force' module parameter that enables
>> the interrupt mode on some machines but then ends up circumventing ACPI to
>> determine whether an Intel iTPM is present to activate the work-around. So,
>> in that case we can rely on the probing.
>>
>> Patch 12 fixes a typo.
>>
>> I have tested these patches on four different types of machines. They worked
>> fine there even though the TPM could not be used in interrupt mode on all of
>> them (IRQ line not connected?).
>>
>> V2:
>>    - following Rajiv's feedback. Splitting the durations and timeout
>>      patches in 3 parts.
>>    - slightly rearranging the order of the patches
>>
>>    Regards,
>>           Stefan
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>

