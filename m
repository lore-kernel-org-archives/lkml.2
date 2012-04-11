Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab2DKKJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:09:08 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:49823 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab2DKKJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:09:07 -0400
Message-ID: <4F85583F.6050008@emc.com.tw>
Date: Wed, 11 Apr 2012 18:09:03 +0800
From: =?UTF-8?B?5p6X5b2l5L2R?= <tom_lin@emc.com.tw>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        djkurtz@chromium.org
Subject: Re: [PATCH v3] Input: Elan HID-I2C device driver
References: <1334061766-20577-1-git-send-email-tom_lin@emc.com.tw> <20120411071212.GB6894@core.coreip.homeip.net>
In-Reply-To: <20120411071212.GB6894@core.coreip.homeip.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel


On 04/11/2012 03:12 PM, Dmitry Torokhov wrote:
> Hi Tom,
>
> On Tue, Apr 10, 2012 at 08:42:46PM +0800, Tom Lin wrote:
>> This patch adds driver for Elan I2C touchpad. These protocol of HID-I2C was
>> defined by Microsoft. The kernel driver would use the multi-touch protocol
>> format B.
>>
>
> If this device truly supports HID protocol shouldn't we define i2c-hid
> transport, similar to usbhid?
I merely follow defined by Microsoft.
It was called "HID OVER I2C" by Microsoft.
(http://msdn.microsoft.com/en-us/library/windows/hardware/hh825917(v=vs.85).aspx)
But I agree to change from hid i2c to i2chid.
Do you have any better opinions?
>
> Thanks.
>

