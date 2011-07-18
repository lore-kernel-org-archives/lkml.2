Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab1GRMAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 08:00:17 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48359 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756518Ab1GRMAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 08:00:15 -0400
Message-ID: <4E242049.1030604@linux.vnet.ibm.com>
Date: Mon, 18 Jul 2011 08:00:09 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: rdunlap@xenotime.net, Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>, linux-next@vger.kernel.org
Subject: Re: [PATCH] tpm: Fix compilation warning when CONFIG_PNP is not defined
References: <1310903758.15064.9.camel@d941e-10> <20110718091624.bd262188190c5d7a05416b99@canb.auug.org.au>
In-Reply-To: <20110718091624.bd262188190c5d7a05416b99@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2011 07:16 PM, Stephen Rothwell wrote:
> Hi Stefan,
>
> On Sun, 17 Jul 2011 07:55:58 -0400 Stefan Berger<stefanb@linux.vnet.ibm.com>  wrote:
>> The is_itpm() function is only accessed from a block surrounded by
>> #ifdef CONFIG_PNP. Therefore, also surround it with #ifdef CONFIG_PNP
>                  ^^^
>
>> --- linux-2.6.orig/drivers/char/tpm/tpm_tis.c
>> +++ linux-2.6/drivers/char/tpm/tpm_tis.c
>> @@ -80,7 +80,7 @@ enum tis_defaults {
>>   static LIST_HEAD(tis_chips);
>>   static DEFINE_SPINLOCK(tis_lock);
>>
>> -#ifdef CONFIG_ACPI
>> +#ifdef CONFIG_PNPN
>                   ^^^^
> Is this a typo?
>
Argh, yes.

    Stefan

