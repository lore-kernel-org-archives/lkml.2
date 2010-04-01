Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab0DAOXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 10:23:48 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52878 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab0DAOXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 10:23:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ad3qL2bdpIeMaeTMLNSNUEVC3plRo23EJI/KhgYYMRGfE8OiA2b1l1/O/KjinGRx/J
         EdcCpkgDW7tnhahWdOISSZFJ7PuKUzHtv1nBfUlonzBqcsPWrl1Ro/fgyPqsdVBIsRRK
         aPZ9wF2vityRNn82RRbMnuwQzSxk7tXMBjinM=
Message-ID: <4BB4AC91.9020101@gmail.com>
Date: Thu, 01 Apr 2010 07:24:17 -0700
From: "Justin P. mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove empty comment.
References: <1270077774-4399-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1004011119520.8345@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1004011119520.8345@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 02:20 AM, Jiri Kosina wrote:
> On Wed, 31 Mar 2010, Justin P. Mattock wrote:
>
>> Remove an empty comment.
>>
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>> ---
>>   drivers/acpi/power.c |    1 -
>>   1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
>> index 0f30c3c..8ed24c2 100644
>> --- a/drivers/acpi/power.c
>> +++ b/drivers/acpi/power.c
>> @@ -171,7 +171,6 @@ static int acpi_power_get_list_state(struct acpi_handle_list *list, int *state)
>>   		return -EINVAL;
>>
>>   	/* The state of the list is 'on' IFF all resources are 'on'. */
>> -	/* */
>>
>>   	for (i = 0; i<  list->count; i++) {
>>   		/*
>
> Applied, thanks Justin.
>

o.k.

Justin P. Mattock
