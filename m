Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab1CRInM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 04:43:12 -0400
Received: from smtp.nokia.com ([147.243.1.48]:49357 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755028Ab1CRInI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 04:43:08 -0400
Message-ID: <4D831AEF.3020109@nokia.com>
Date: Fri, 18 Mar 2011 10:42:23 +0200
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: ext Arnd Bergmann <arnd@arndb.de>
CC: Greg KH <greg@kroah.com>, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, <andy.green@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <20110311161421.GA7843@kroah.com> <20110317201835.GM31411@opensource.wolfsonmicro.com> <20110317202614.GA3155@kroah.com> <201103172311.36246.arnd@arndb.de>
In-Reply-To: <201103172311.36246.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [131.228.1.90]
X-OriginalArrivalTime: 18 Mar 2011 08:42:32.0071 (UTC) FILETIME=[6BE42170:01CBE548]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2011 12:11 AM, ext Arnd Bergmann wrote:
> On Thursday 17 March 2011 21:26:14 Greg KH wrote:
>>> It's going to be an off the shelf USB ethernet controller.  I'd be
>>> astonished if the board-configurable device IDs weren't set from the
>>> same SEPROM that the MAC address is so it'd just show up as a generic
>>> chip of whatever kind.
>>
>> Huh?  All USB controllers you buy have the ability to set the vendor and
>> product id, so you should always be able to key off of that.
>>
>> Isn't that the case here?
> 
> The same EEPROM that is missing here carries both the MAC address and
> the vendor/product ID overrides.
> 

Just curious, how do Panda boards manage to get the MAC address? Is it
programmed in some other flash memory?

The LAN9514 datasheet says
"If a properly configured EEPROM is not detected, it is the
responsibility of the Host LAN Driver to set the IEEE addresses."

So how does the Host LAN driver know what MAC address it should use?

-- 
regards,
-roger
