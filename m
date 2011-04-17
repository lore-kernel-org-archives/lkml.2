Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab1DQUfU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 16:35:20 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:49099 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab1DQUfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 16:35:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=t8KhOqrtM1/emrBm7FwOEN7D6Mwt3OKb2yJUxbzQRvNH3wWOtIEBs1GGr0WDGVIFct
         b/Uj/ncZwR7UEDi0OfwoFrveq0eSOJ/zEg1YSYD4i9zODlu69eIBKhEjsgx5ld21MsmG
         rx5n3xtyPTQKt5WXMWgxm49f8QTwZljANuxOU=
Message-ID: <4DAB4EFA.40606@gmail.com>
Date: Sun, 17 Apr 2011 13:35:06 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5 v2]Typo: Remove one to many ccc's in some comments.
References: <1303063749-8282-1-git-send-email-justinmattock@gmail.com>	<1303063749-8282-3-git-send-email-justinmattock@gmail.com> <20110417120336.49f71508.rdunlap@xenotime.net>
In-Reply-To: <20110417120336.49f71508.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2011 12:03 PM, Randy Dunlap wrote:
> On Sun, 17 Apr 2011 11:09:07 -0700 Justin P. Mattock wrote:
>
>> The below patch is a resend due to rebasing to the current Mainline, fixing
>> some comments due to having one to many ccc's in the definitions.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   arch/m68k/include/asm/MC68EZ328.h |    2 +-
>>   arch/m68k/include/asm/MC68VZ328.h |    2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/m68k/include/asm/MC68EZ328.h b/arch/m68k/include/asm/MC68EZ328.h
>> index 69b7f91..b2ee25d 100644
>> --- a/arch/m68k/include/asm/MC68EZ328.h
>> +++ b/arch/m68k/include/asm/MC68EZ328.h
>> @@ -1047,7 +1047,7 @@ typedef volatile struct {
>>
>>   #define WATCHDOG_EN	0x0001	/* Watchdog Enabled */
>>   #define WATCHDOG_ISEL	0x0002	/* Select the watchdog interrupt */
>> -#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occcured */
>> +#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occured */
>
>                                                                occurred
> (above and below)

yep!! made a mistake with this one, and resent..
>
>>   #define WATCHDOG_CNT_MASK  0x0300	/* Watchdog Counter */
>>   #define WATCHDOG_CNT_SHIFT 8
>>
>> diff --git a/arch/m68k/include/asm/MC68VZ328.h b/arch/m68k/include/asm/MC68VZ328.h
>> index 2b9bf62..62cd79a 100644
>> --- a/arch/m68k/include/asm/MC68VZ328.h
>> +++ b/arch/m68k/include/asm/MC68VZ328.h
>> @@ -1143,7 +1143,7 @@ typedef struct {
>>
>>   #define WATCHDOG_EN	0x0001	/* Watchdog Enabled */
>>   #define WATCHDOG_ISEL	0x0002	/* Select the watchdog interrupt */
>> -#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occcured */
>> +#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occured */
>>   #define WATCHDOG_CNT_MASK  0x0300	/* Watchdog Counter */
>>   #define WATCHDOG_CNT_SHIFT 8
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>

