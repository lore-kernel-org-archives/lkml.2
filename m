Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab0EDLQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 07:16:09 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:50574 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106Ab0EDLQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 07:16:07 -0400
Message-ID: <4BE001E7.9030605@euromail.se>
Date: Tue, 04 May 2010 13:15:51 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Alex Murray <murray.alex@gmail.com>
Subject: Re: [PATCH] hwmon: applesmc: Add temperature sensor labels to sysfs
 interface
References: <1272966929-14501-1-git-send-email-rydberg@euromail.se> <20100504120638.70244e8e@hyperion.delvare>
In-Reply-To: <20100504120638.70244e8e@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1O9G6T-0005pi-6X.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1O9G6T-0005pi-6X f4bee223e5c0dd5deb8347ac999746ff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
[...]
>> @@ -1578,6 +1717,8 @@ static int __init applesmc_init(void)
>>  		}
>>  		ret = sysfs_create_file(&pdev->dev.kobj,
>>  						temperature_attributes[i]);
> 
> Missing error handling.
> 
>> +		ret = sysfs_create_file(&pdev->dev.kobj,
>> +						label_attributes[i]);
>>  		if (ret)
>>  			goto out_temperature;
>>  	}
>

Shoot, my bad review. Will send a new patch. While at it, the same function
seems to leak fan attribute groups. Want me to correct such issues (in another
patch)?

Henrik

