Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab2IAJbr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 05:31:47 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:65533 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753102Ab2IAJbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 05:31:46 -0400
Message-ID: <5041D5DF.7060402@metafoo.de>
Date: Sat, 01 Sep 2012 11:31:11 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] hwmon: add Maxim MAX197 support
References: <1346377377-24717-1-git-send-email-vivien.didelot@savoirfairelinux.com> <20120831160439.GA5756@roeck-us.net>
In-Reply-To: <20120831160439.GA5756@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2012 06:04 PM, Guenter Roeck wrote:
> On Thu, Aug 30, 2012 at 09:42:57PM -0400, Vivien Didelot wrote:
>> The MAX197 is an A/D converter, made by Maxim. This driver currently
>> supports the MAX197, and MAX199. They are both 8-Channel, Multi-Range,
>> 5V, 12-Bit DAS with 8+4 Bus Interface and Fault Protection.
>>
>> The available ranges for the MAX197 are {0,-5V} to 5V, and {0,-10V} to
>> 10V, while they are {0,-2V} to 2V, and {0,-4V} to 4V on the MAX199.
>>
>> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> 
> Applied to -next.
> 

Hm, now it's probably to late, but for this kind of general purpose ADC the IIO
framework is in my opinion the better place to add support for it.

- Lars
