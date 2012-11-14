Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778Ab2KNJIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:08:23 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:46125 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab2KNJIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:08:20 -0500
Message-ID: <50A35F77.8060901@ahsoftware.de>
Date: Wed, 14 Nov 2012 10:08:07 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Till Harbaum <till@harbaum.org>
Subject: Re: [PATCH 1/2] i2c: Add possibility for user-defined (i2c-)devices
 for bus-drivers.
References: <1352829968-4908-1-git-send-email-holler@ahsoftware.de> <20121113195533.6db71716@endymion.delvare> <50A2AC28.7050304@ahsoftware.de> <20121113220835.111a178a@endymion.delvare> <50A2BAA2.6090009@ahsoftware.de> <20121113224246.768bf734@endymion.delvare> <50A30652.1020208@ahsoftware.de>
In-Reply-To: <50A30652.1020208@ahsoftware.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.11.2012 03:47, schrieb Alexander Holler:
> Hello,
>
> Am 13.11.2012 22:42, schrieb Jean Delvare:
>
>> Plus you don't address the main issues. Your syntax gives you no way to
>> support two i2c-tiny-usb adapters with different chips at a specific
>> address. The sysfs interface supports such a setup. Also instantiating
>> the wrong devices is worse than instating a device that doesn't exist
>> at all. So the use of i2c_new_probed_device() here will randomly help
>> in a limited number of cases and randomly be problematic in others.
>> Hard to justify...
>
> As you seem to have a solution for multiple devices of the same type by
> using sysfs, how to do you decide which one to use? You might be able to
> probe just one, but my simple mind currently doesn't come up with a
> solution which device one has to probe. Just because I'm curious... ;)

And while we are at artificial problems, I've just seen a small problem 
in my patch which might occur if someone really uses two of those 
devices. I've already fixed it here, but until one of you gives me the 
ok for inclusion into the mainline, I don't want to waste more of your 
valuable time with posting a corrected patch for something no one of you 
wants.

Regards,

Alexander
