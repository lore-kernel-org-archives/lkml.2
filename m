Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab1E3P1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 11:27:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57775 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab1E3P1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 11:27:39 -0400
Message-ID: <4FF0051BF59A4F94A5CB49DFD97F9D4A@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Greg KH" <greg@kroah.com>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Samuel Ortiz" <sameo@linux.intel.com>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <201105301604.38026.arnd@arndb.de> <2AF43CEDFDB649AE946E8F9F98A5AE48@subhasishg> <201105301643.35997.arnd@arndb.de>
In-Reply-To: <201105301643.35997.arnd@arndb.de>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver
Date: Mon, 30 May 2011 20:58:35 +0530
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

> On Monday 30 May 2011, Subhasish Ghosh wrote:
>> >
>> > During the time when the drivers are in staging, all files need to
>> > be in the same directory, including the header and the drivers using 
>> > it.
>> > They can get moved at the time when the driver gets turned into
>> > a regular non-staging driver.
>>
>> OK, so the UART implementation needs to be moved into staging as well ?
>>
>> And what about the boardfile changes, array of mfd_cells implementation 
>> etc.
>
> All of that, too.
>
> Note that you are citing exactly the points that are the reason for the
> discussion we are having. The mfd_cells are the main concern for the cases
> where the information is not static.

Yes, but by destroying the structure that I have currently in the platform 
files,
I will be basically going backwards.

If only the platform_data is what is going to change with some additions
of sysfs attributes, then will it be correct to have the platform data
as an empty pointer and keep the rest as is ?

That way, I can keep the platform changes untouched and move just
the drivers into staging.

I cannot destroy the complete platform code as there are other drivers
(PRUSS UIO) depending on them. 

