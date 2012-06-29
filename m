Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab2F2DGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 23:06:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35759 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab2F2DGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 23:06:40 -0400
Message-ID: <4FED1BBB.1030303@acm.org>
Date: Thu, 28 Jun 2012 22:06:35 -0500
From: Corey Minyard <tcminyard@gmail.com>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Srinivas_G_Gowda@Dell.com, tcminyard@gmail.com,
        linux-kernel@vger.kernel.org,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH 1/1 v2 ] ipmi: Setting OS name as Linux in BMC
References: <4FEC8931.5020001@dell.com> <4FEC8A28.4070806@dell.com> <m2k3yrgf4d.fsf@firstfloor.org>
In-Reply-To: <m2k3yrgf4d.fsf@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srinivas, what is your use case?

-corey

On 06/28/2012 07:01 PM, Andi Kleen wrote:
> <Srinivas_G_Gowda@Dell.com> writes:
>> +	
>> +	data[0] = param_select;
>> +	data[1] = set_selector;
>> +	data[2] = string_encode;
>> +	data[3] = str_len;
>> +	data[4] = 'L';
>> +	data[5] = 'i';
>> +	data[6] = 'n';
>> +	data[7] = 'u';
>> +	data[8] = 'x';
> Not sure that's all that useful. I can just see BMC's making the ACPI
> mistake of trying to work around specific issues, by checking for
> Linux.
>
> But since there are so many different Linux that will never work
> because "Linux" does not describe a fixed release or code base.
>
> Probably dangerous.
>
> -Andi
>
>


