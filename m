Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab1CRJzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 05:55:48 -0400
Received: from smtp.nokia.com ([147.243.1.48]:52281 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932366Ab1CRJzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 05:55:44 -0400
Message-ID: <4D832BF4.9000004@nokia.com>
Date: Fri, 18 Mar 2011 11:55:00 +0200
From: Roger Quadros <roger.quadros@Nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: ext Arnd Bergmann <arnd@arndb.de>
CC: Greg KH <greg@kroah.com>, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, <andy.green@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <20110311161421.GA7843@kroah.com> <201103172311.36246.arnd@arndb.de> <4D831AEF.3020109@nokia.com> <201103181001.17308.arnd@arndb.de>
In-Reply-To: <201103181001.17308.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [131.228.1.90]
X-OriginalArrivalTime: 18 Mar 2011 09:55:03.0619 (UTC) FILETIME=[8D9DA930:01CBE552]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2011 11:01 AM, ext Arnd Bergmann wrote:
> On Friday 18 March 2011, Roger Quadros wrote:
>> Just curious, how do Panda boards manage to get the MAC address? Is it
>> programmed in some other flash memory?
>>
>> The LAN9514 datasheet says
>> "If a properly configured EEPROM is not detected, it is the
>> responsibility of the Host LAN Driver to set the IEEE addresses."
>>
>> So how does the Host LAN driver know what MAC address it should use?
> 
> This is the problem we're trying to work out. The EEPROM is not
> present, and user space has no way of knowing which MAC address
> to set to which device. Note that there might be multiple
> USB devices of the same type that are indistinguishable to user
> space, so setting the MAC address there would not be completely
> safe.
> 

And what happens if you need to use u-boot or some bootloader with
ethernet network support?

Wouldn't it be better to have the MAC address programmed at the
bootloader level?

-- 
regards,
-roger
