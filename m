Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab2JCQOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:14:14 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40943 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab2JCQOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:14:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAN+gG=EGMs4CMsj19JBGgwgxBDiuhQFstiEvMv3FR_N2pX+9SA@mail.gmail.com>
References: <1347630103-4105-1-git-send-email-benjamin.tissoires@gmail.com>
	<CAM=Q2cuVa9yLY7-nRz26OYktgM3i+dOfDa8vVznwMVrs9pH5sg@mail.gmail.com>
	<CAN+gG=EGMs4CMsj19JBGgwgxBDiuhQFstiEvMv3FR_N2pX+9SA@mail.gmail.com>
Date: Wed, 3 Oct 2012 21:44:09 +0530
Message-ID: <CAM=Q2cv7Qc9Up5b_033uwaunnBz1mB4UWbb1bh9TGzX5=FxFrg@mail.gmail.com>
Subject: Re: [PATCH v1] i2c-hid: introduce HID over i2c specification implementation
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, fabien.andre@gmail.com,
        scott.liu@emc.com.tw, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 9:03 PM, Benjamin Tissoires
<benjamin.tissoires@gmail.com> wrote:
> Hi,
>
> thanks also for the review. Two in the same day! I was about to send a
> ping on that patch.... ;-)
>
> On Wed, Oct 3, 2012 at 8:05 AM, Shubhrajyoti Datta
> <omaplinuxkernel@gmail.com> wrote:
>> On Fri, Sep 14, 2012 at 7:11 PM, benjamin.tissoires
>> <benjamin.tissoires@gmail.com> wrote:
>>> From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>>>
>>> Microsoft published the protocol specification of HID over i2c:
>>> http://msdn.microsoft.com/en-us/library/windows/hardware/hh852380.aspx
>>>
>>> This patch introduces an implementation of this protocol.
>>>
>>> This implementation does not includes the ACPI part of the specification.
>>> This will come when ACPI 5.0 devices will be available.
>>>
>>> Once the ACPI part will be done, OEM will not have to declare HID over I2C
>>> devices in their platform specific driver.
>>>
>>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>>> ---
>>>
>>> Hi,
>>>
>>> this is finally my first implementation of HID over I2C.
>>>
>>> This has been tested on an Elan Microelectronics HID over I2C device, with
>>> a Samsung Exynos 4412 board.
>>>
>>> Any comments are welcome.
>>>
>>> Cheers,
>>> Benjamin
>>>
>>>  drivers/i2c/Kconfig         |    8 +
>>>  drivers/i2c/Makefile        |    1 +
>>>  drivers/i2c/i2c-hid.c       | 1027 +++++++++++++++++++++++++++++++++++++++++++
>>>  include/linux/i2c/i2c-hid.h |   35 ++
>>>  4 files changed, 1071 insertions(+)
>>>  create mode 100644 drivers/i2c/i2c-hid.c
>>>  create mode 100644 include/linux/i2c/i2c-hid.h
>>>
>>> diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
>>
[...]
>
> same thing, will change it in v2.
>
>>
>>> +
>>> +       if (debug)
>>> +               dev_err(&client->dev, "resetting...\n");
>> this is a little uncustomary.
>>
>> May be consider  bdg
>
> Sorry for that. I don't get your point here. You don't like the whole
> "if(debug) dev_err(...)" or just the "dev_err(...)" call?
>
Apologies for the typo dev_dbg.
