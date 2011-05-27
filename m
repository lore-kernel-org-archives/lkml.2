Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab1E0U4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 16:56:05 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56415 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab1E0U4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 16:56:02 -0400
Message-ID: <4DE00FDC.309@linux.vnet.ibm.com>
Date: Fri, 27 May 2011 16:55:56 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
CC: jirislaby@gmail.com, preining@logic.at
Subject: Re: [PATCH V2 00/12] tpm + tpm_tis : Various fixes
References: <20110330161322.015113054@linux.vnet.ibm.com>
In-Reply-To: <20110330161322.015113054@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rajiv,

   are you planning to use these patches?

Regards,
    Stefan


On 03/30/2011 12:13 PM, Stefan Berger wrote:
> This patchset fixes various issues in the general TPM driver and the TPM TIS
> driver. Some of the patches were previously posted, and are being re-posted
> without change, while other patches were refactored. This patchset applies to
> the tip of the main git tree.
>
> Patches 1-6 are related to using the timeouts that the TPM reports, along with
> work-arounds for TPMs that don't report the timeouts in microseconds but
> rather in milliseconds.
>
> Patch 7 fixes the display of the public key of the TPM's Endorsement Key in
> sysfs.
>
> Patch 8 re-enables the TPM's interrupts after resume from S3.
>
> Patch 9 is useful if the TPM is run in interrupt mode and delays the S3 suspend
> until the TPM has finished processing a command.
>
> Patch 10 fixes several aspects of the code around the probing for interrupts.
>
> Patch 11 introduces automatic probing for the Intel iTPM flaw. The probing
> is useful in combination with the 'force' module parameter that enables
> the interrupt mode on some machines but then ends up circumventing ACPI to
> determine whether an Intel iTPM is present to activate the work-around. So,
> in that case we can rely on the probing.
>
> Patch 12 fixes a typo.
>
> I have tested these patches on four different types of machines. They worked
> fine there even though the TPM could not be used in interrupt mode on all of
> them (IRQ line not connected?).
>
> V2:
>    - following Rajiv's feedback. Splitting the durations and timeout
>      patches in 3 parts.
>    - slightly rearranging the order of the patches
>
>    Regards,
>           Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

