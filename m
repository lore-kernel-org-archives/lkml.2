Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab1C3RtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 13:49:17 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47340 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab1C3RtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 13:49:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tg+zG4FbIYSuDirxsA32sC5DPLy1WjjEctyZdeX8eDRH750TjD6pgphV4gixSnLTQp
         z4AE2nmmdyjXvyyBdJAXRi+4CEX0+tfEF+wmiXkDHhfgXU0ZJSvelqyklh4ToFka2xQs
         prowL2VxfSODY48R6LXTZM/3APR+ET7GmUN4E=
Message-ID: <4D936D14.8080204@gmail.com>
Date: Wed, 30 Mar 2011 10:49:08 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110316 Thunderbird/3.1.9
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5]arch:m68k:asm Remove one to many ccc's.
References: <1301504478-3450-1-git-send-email-justinmattock@gmail.com>    <1301504478-3450-3-git-send-email-justinmattock@gmail.com> <a69599be848c8abb3e136823ad788bfc.squirrel@xenotime.net>
In-Reply-To: <a69599be848c8abb3e136823ad788bfc.squirrel@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2011 10:44 AM, Randy Dunlap wrote:
>
> On Wed, March 30, 2011 10:01 am, Justin P. Mattock wrote:
>> The patch below removes one to many ccc's in some comments.
>
> The patch also needs to add an 'r':  "occurred"
>
>

missed a fix in a fix again... will resend..

Thanks for having a look.

>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   arch/m68k/include/asm/MC68EZ328.h |    2 +-
>>   arch/m68k/include/asm/MC68VZ328.h |    2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/m68k/include/asm/MC68EZ328.h
>> b/arch/m68k/include/asm/MC68EZ328.h
>> index 69b7f91..b2ee25d 100644
>> --- a/arch/m68k/include/asm/MC68EZ328.h
>> +++ b/arch/m68k/include/asm/MC68EZ328.h
>> @@ -1047,7 +1047,7 @@ typedef volatile struct {
>>
>>   #define WATCHDOG_EN	0x0001	/* Watchdog Enabled */
>>   #define WATCHDOG_ISEL	0x0002	/* Select the watchdog interrupt */
>> -#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occcured */
>> +#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occured */
>>   #define WATCHDOG_CNT_MASK  0x0300	/* Watchdog Counter */
>>   #define WATCHDOG_CNT_SHIFT 8
>>
>> diff --git a/arch/m68k/include/asm/MC68VZ328.h
>> b/arch/m68k/include/asm/MC68VZ328.h
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
>>
>> --
>
>

