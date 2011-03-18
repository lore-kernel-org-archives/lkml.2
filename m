Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab1CRSJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 14:09:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47712 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab1CRSJq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 14:09:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bQfyaMsY6VPPjZG9R/sVMJv8SKYExUVmRwPToE/dMT4oYEmIgMoYESgYHlJs0wbqg4
         bGldgSPRmbKDUTEVXB3rK13+7pvmfKvamYGwoCITDTQcBLwkz5Q/T2xZHZhNhJ71L9Vu
         c3moCPPpUXH2Y/ec63f6yk+fX4YSe0lmZozcg=
MIME-Version: 1.0
In-Reply-To: <20110308123541.GA11804@khazad-dum.debian.net>
References: <1299540407-3779-1-git-send-email-manoj.iyer@canonical.com>
	<1299540407-3779-2-git-send-email-manoj.iyer@canonical.com>
	<20110308123541.GA11804@khazad-dum.debian.net>
Date: Fri, 18 Mar 2011 13:09:44 -0500
X-Google-Sender-Auth: 6asDht45U97r4B8wDHuUlHH8Raw
Message-ID: <AANLkTinDQbCX4kkm8DOuJZfM_gNQU+BXaF5gASafCCUQ@mail.gmail.com>
Subject: Re: [PATCH] thinkpad-acpi: module autoloading for newer Lenovo ThinkPads.
From: Manoj Iyer <manoj.iyer@canonical.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique,

Thanks the ack on the patch, any idea when this will be Q'ed for linus tree ?

-----------------------------------------------------
Manoj Iyer
Ubuntu/Canonical
Hardware Enablement Team
------------------------------------------------------



On Tue, Mar 8, 2011 at 6:35 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Mon, 07 Mar 2011, Manoj Iyer wrote:
>> The newer Lenovo ThinkPads have HKEY HID of LEN0068 instead
>> of IBM0068. Added new HID so that thinkpad_acpi module will
>> auto load on these newer Lenovo ThinkPads.
>>
>> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
>
> Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
>
>> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
>> index eb99223..125d891 100644
>> --- a/drivers/platform/x86/thinkpad_acpi.c
>> +++ b/drivers/platform/x86/thinkpad_acpi.c
>> @@ -128,7 +128,8 @@ enum {
>>  };
>>
>>  /* ACPI HIDs */
>> -#define TPACPI_ACPI_HKEY_HID         "IBM0068"
>> +#define TPACPI_ACPI_IBM_HKEY_HID     "IBM0068"
>> +#define TPACPI_ACPI_LENOVO_HKEY_HID  "LEN0068"
>>  #define TPACPI_ACPI_EC_HID           "PNP0C09"
>>
>>  /* Input IDs */
>> @@ -3879,7 +3880,8 @@ errexit:
>>  }
>>
>>  static const struct acpi_device_id ibm_htk_device_ids[] = {
>> -     {TPACPI_ACPI_HKEY_HID, 0},
>> +     {TPACPI_ACPI_IBM_HKEY_HID, 0},
>> +     {TPACPI_ACPI_LENOVO_HKEY_HID, 0},
>>       {"", 0},
>>  };
>
> --
>  "One disk to rule them all, One disk to find them. One disk to bring
>  them all and in the darkness grind them. In the Land of Redmond
>  where the shadows lie." -- The Silicon Valley Tarot
>  Henrique Holschuh
>
