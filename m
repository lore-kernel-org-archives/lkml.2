Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab1AAOxN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 09:53:13 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46698 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab1AAOxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 09:53:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=BcUKzBZ+XvrJxbBYB790rJsNbqqnAPYkQ2p6SP5FXIKF+DtUL1V0LpI7mKZfihYgzw
         ZQgPrnr146XUEgkB42Wx8Eq3YeafwBSjnkpVLv7TNe+kbdBXvDXdrUFvTKUA3ewCRIN2
         eKX09fd9NxEJRVkvHhGYuoqSahH3ORR0zDXiA=
Message-ID: <4D1F3FEE.7@gmail.com>
Date: Sat, 01 Jan 2011 06:53:34 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101220 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Finn Thain <fthain@telegraphics.com.au>,
        devel@driverdev.osuosl.org, trivial@kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, ivtv-devel@ivtvdriver.org,
        linux-m68k@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 03/15]drivers:staging:rtl8187se:r8180_hw.h Typo change
 diable to disable.
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com> <1293750484-1161-2-git-send-email-justinmattock@gmail.com> <1293750484-1161-3-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1012311722580.24460@nippy.intranet> <4D1EDB22.2020308@gmail.com> <20110101090931.GH1886@bicker>
In-Reply-To: <20110101090931.GH1886@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/2011 01:09 AM, Dan Carpenter wrote:
> On Fri, Dec 31, 2010 at 11:43:30PM -0800, Justin P. Mattock wrote:
>> On 12/31/2010 10:48 PM, Finn Thain wrote:
>>>> -/*  BIT[8-9] is for SW Antenna Diversity. Only the value EEPROM_SW_AD_ENABLE means enable, other values are diable.					*/
>>>> +/*  BIT[8-9] is for SW Antenna Diversity. Only the value EEPROM_SW_AD_ENABLE means enable, other values are disabled.					*/
>>>
>>> I think, "other values disable" was what you meant?
>>>
>>> Finn
>>>
>>>>   #define EEPROM_SW_AD_MASK			0x0300
>>>>   #define EEPROM_SW_AD_ENABLE			0x0100
>>>>
>>>>
>>>
>>
>> no! I changed it to disabled to make it proper..
>
> Finn is obviously right, but maybe a compromise would be:
>
> Only the value EEPROM_SW_AD_ENABLE means "enable", other values mean
> "disable".
>
> regards,
> dan carpenter
>

ahh.. I see what you your saying now.. alright let me send this out that 
way..

Justin P. Mattock
