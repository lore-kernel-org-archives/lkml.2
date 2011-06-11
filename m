Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab1FKKbj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 06:31:39 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41019 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab1FKKbi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 06:31:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=KXd6Dfg/U4TtvVXtImj2eKhB/bqc5zX5uDWTC+7hdMxjkIocspI6uqoCNI5Abz/HEb
         avZPn8RV2N98Oc5+woTzcO5SO3Qyly/gX8Y51Uh6OgYPLiJaWxSa05sK6mlNR+CNs82M
         GPJ7NRHwdig2dMv/DPyDGuhRtIVUDNI+tIeOw=
MIME-Version: 1.0
In-Reply-To: <36678F5D6E8A4CB2AD6723B10C6B03D6@delorimier>
References: <1307725425.4266.23.camel@vivanov>
	<36678F5D6E8A4CB2AD6723B10C6B03D6@delorimier>
Date: Sat, 11 Jun 2011 13:31:36 +0300
Message-ID: <BANLkTikgRujPZ+7+yXRq_BhwBDRXa3de-g@mail.gmail.com>
Subject: Re: [BUGFIX] [PATCH] APM: Dynamic select of APM_CPU_IDLE on APM enabling.
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: David Hill <hilld@binarystorm.net>, apmbugs@rothwell.emu.id.au,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks David.

On Sat, Jun 11, 2011 at 3:38 AM, David Hill <hilld@binarystorm.net> wrote:
>
> Hi !
>
>   Recompiling the kernel with APM_CPU_IDLE solves the issue.

Please update the defect.

>
> Thank you very much,
>
> David C. Hill
> ----- Original Message ----- From: "Vitaliy Ivanov" <vitalivanov@gmail.com>
> To: <linux-kernel@vger.kernel.org>
> Cc: <hilld@binarystorm.net>; <apmbugs@rothwell.emu.id.au>; <vitalivanov@gmail.com>
> Sent: Friday, June 10, 2011 1:03 PM
> Subject: [BUGFIX] [PATCH] APM: Dynamic select of APM_CPU_IDLE on APM enabling.
>
>
>>
>> Bug fix for #36902:
>> https://bugzilla.kernel.org/show_bug.cgi?id=36902
>>
>> I saw email about removing APM completely but as of now we can add the following to close build issue.
>> ---
>>
>> Dynamic select of APM_CPU_IDLE feature for enabling APM.
>>
>> Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
>>
>>> From f00634bec035f1526266340bf75aa4e2620c8284 Mon Sep 17 00:00:00 2001
>>
>> From: Vitaliy Ivanov <vitalivanov@gmail.com>
>> Date: Fri, 10 Jun 2011 19:06:37 +0300
>> Subject: [PATCH] Dynamic select of APM_CPU_IDLE on APM enabling.
>>
>> ---
>> arch/x86/Kconfig |    1 +
>> 1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index da34972..3c9b459 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -1721,6 +1721,7 @@ config X86_APM_BOOT
>>
>> menuconfig APM
>>  tristate "APM (Advanced Power Management) BIOS support"
>> + select APM_CPU_IDLE
>>  depends on X86_32 && PM_SLEEP
>>  ---help---
>>   APM is a BIOS specification for saving power using several different
>> --
>> 1.7.0.4
