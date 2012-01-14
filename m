Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab2ANWPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 17:15:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48595 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab2ANWPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 17:15:24 -0500
Message-ID: <4F11FE6C.8020808@gmail.com>
Date: Sat, 14 Jan 2012 16:15:08 -0600
From: Alejandro <scasbyte@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: guenter.roeck@ericsson.com, linux-kernel@vger.kernel.org,
        Rodolfo Giometti <giometti@linux.it>
Subject: Re: [RFC][PATCH 2/2] hwmon: (w83627ehf) Add GPIO port 3 functionality
References: <CAPbJ=B=_Xubsni7R00kSotDQ9AE9jmhmyRV0gPkXGqAPGrNaXg@mail.gmail.com> <20120114211856.7e1b816d@endymion.delvare>
In-Reply-To: <20120114211856.7e1b816d@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Delvare,

On 14-Jan-12 2:18 PM, Jean Delvare wrote:
> On Fri, 13 Jan 2012 19:39:56 -0600, Alex Rio wrote:
>> The w83627ehf chip has 5 GPIO ports, currently none of them is supported.
>> This patch adds the GPIO port 3 driver with the following functions:
>> set/get pin values, direction_in/out, set_debounce.
>> The values are also available to the userspace (if requiered)
>> in the path /sys/class/gpio by using the export/unexport functions.
>> Please look at the REVISIT comment, this is the main reason of the RFC,
>> suggestions will be highly appreciated.
>>
>> Signed-off-by: Alex Rio<scasbyte@gmail.com>
>> ---
>>   drivers/hwmon/w83627ehf.c |  188 +++++++++++++++++++++++++++++++++++++++++++++
>>   1 files changed, 188 insertions(+), 0 deletions(-)
>
> This is calling for a MFD driver for these chips. This was proposed in
> the past, BTW, but never followed up:
> http://lists.lm-sensors.org/pipermail/lm-sensors/2010-February/027795.html
>
> Putting everything in the current driver is not going to be accepted.
> It certainly looks pleasant because it's a more simple approach, but
> the result would be a complex and unmaintainable driver.
>

The patch looks great, and it is definitely more maintainable. I'll 
create a patch for the w83627ehf driver and send it as soon as possible. 
Should I make the patch for the w83627hf or wait for Rodolfo???

BR, Alex.
