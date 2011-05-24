Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab1EXMQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 08:16:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52904 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab1EXMQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 08:16:51 -0400
Message-ID: <7E10264BABCB4C1788DCD9715461BDE8@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Samuel Ortiz" <sameo@linux.intel.com>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <201105151133.23870.arnd@arndb.de> <B876E8072D52496DB747D5CCCF64826D@subhasishg> <201105231730.06564.arnd@arndb.de>
In-Reply-To: <201105231730.06564.arnd@arndb.de>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
Date: Tue, 24 May 2011 17:47:32 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

>> http://linux.omap.com/pipermail/davinci-linux-open-source/
>> 2011-March/022339.html.
>>
>> We can use this implementation along with the sysfs to load the devices
>> runtime.
>
> Possibly, but the actual data structures might end up differently
> when they are built around a sysfs interface. If you have a sysfs
> interface, it is more important to have that in a clean way than
> the board file, so we should first discuss the set of sysfs
> attributes that you are going to need, and then see how to
> represent that in platform data for predefined boards.
>
>> The configs that I have in the board_file for the devices
>> structure, are fixed for a board. To swap the boards, we do not need to 
>> re-compile
>> the kernel.
>
> The other point to consider is that we are definitely moving
> towards the flattened device tree for these definitions now.
> It's probably good to make the sysfs attributes directly correspond
> to fdt device properties. I'm not sure if we also need to allow platform
> data. The easiest way could be to just require the use of device tree
> for predefined pruss devices.
>
> I'm sorry that this is moving in a different direction now, you
> had an unfortunate timing here.
>
> Let's first discuss the exact properties that are really required
> to define the differences between PRU backends, as those will
> be required in any case. What do you need for PRU specific
> data besides the firmware and the name of the device?

Would it be a good approach to first get a basic sensible
driver into the tree and then work towards improving and
adjusting for future compatibilities.
That way we can gradually build towards the perfect driver
in steps, rather than digressing far too off suddenly.
That would be some source of motivation for me too.
 

