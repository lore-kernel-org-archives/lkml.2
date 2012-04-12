Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934117Ab2DLBhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 21:37:19 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:41248 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734Ab2DLBhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 21:37:17 -0400
Message-ID: <4F8631C8.1090705@emc.com.tw>
Date: Thu, 12 Apr 2012 09:37:12 +0800
From: =?UTF-8?B?5p6X5b2l5L2R?= <tom_lin@emc.com.tw>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        djkurtz@chromium.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH v3] Input: Elan HID-I2C device driver
References: <1334061766-20577-1-git-send-email-tom_lin@emc.com.tw> <20120411071212.GB6894@core.coreip.homeip.net> <4F85583F.6050008@emc.com.tw> <20120411162519.GA27562@core.coreip.homeip.net>
In-Reply-To: <20120411162519.GA27562@core.coreip.homeip.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry

On 04/12/2012 12:25 AM, Dmitry Torokhov wrote:
> On Wednesday, April 11, 2012 06:09:03 PM 林彥佑 wrote:
>> Hi Daniel
>>
>> On 04/11/2012 03:12 PM, Dmitry Torokhov wrote:
>>> Hi Tom,
>>>
>>> On Tue, Apr 10, 2012 at 08:42:46PM +0800, Tom Lin wrote:
>>>> This patch adds driver for Elan I2C touchpad. These protocol of HID-I2C
>>>> was
>>>> defined by Microsoft. The kernel driver would use the multi-touch
>>>> protocol
>>>> format B.
>>>
>>> If this device truly supports HID protocol shouldn't we define i2c-hid
>>> transport, similar to usbhid?
>>
>> I merely follow defined by Microsoft.
>> It was called "HID OVER I2C" by Microsoft.
>> (http://msdn.microsoft.com/en-us/library/windows/hardware/hh825917(v=vs.85).
>> aspx) But I agree to change from hid i2c to i2chid.
>> Do you have any better opinions?
>
> I am not sure we are talking about same thing... I do not really care
> whether it is named "hid i2c" or "i2chid". What I meant if the device
> really speaks HID protocol, except that the transport is not USB or
> bluetooth but I2C, then instead of writing a custom driver for this
> particular part we need to add a new HID transport into
> drivers/hid/i2c-hid that is similar to drivers/hid/usbhid/ and reuse the
> rest of HID framework along with hid- multitouch.c which handles
> HID-compliant multitouch devices.
>
> I am CCing Jiri (HID maintainer) for additional input.
Sorry! I misunderstood what you mean.
I fully agree with your suggestion. The I2CHID device will be more and 
more in the future. Need the new i2chid-driver that would cover all 
hid-compliant i2c-devices.
Thank you

Tom-
>
> Thanks.
>

