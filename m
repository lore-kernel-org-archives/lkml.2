Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1LZKFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 05:05:06 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:44583 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1LZKE7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 05:04:59 -0500
MIME-Version: 1.0
In-Reply-To: <20111225161320.GA12841@thinkpad>
References: <1324744926-24793-1-git-send-email-alecmn@gmail.com>
	<CANq1E4Qab2sO2QagwmU-66+kUWhpStxVWawEGX=1HCdrM7bgLA@mail.gmail.com>
	<20111225161320.GA12841@thinkpad>
Date: Mon, 26 Dec 2011 11:04:57 +0100
Message-ID: <CANq1E4SzAVfHoU9YpzAyA5UmNv_Lk5kfvxPZjUUTgrt+RdunBw@mail.gmail.com>
Subject: Re: [PATCH 1/1] hid_wiimote: add INPUT_FF_MEMLESS dependency
From: David Herrmann <dh.herrmann@googlemail.com>
To: Alec Moskvin <alecmn@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 25, 2011 at 5:13 PM, Alec Moskvin <alecmn@gmail.com> wrote:
> Hi David,
>
> On Sunday 25 December 2011 11:06:58, David Herrmann wrote:
>> Hi Alec
>>
>> On Sat, Dec 24, 2011 at 5:42 PM, Alec Moskvin <alecmn@gmail.com> wrote:
>> > This fixes build error:
>> > ...
>> > CRC 17a7c33e
>> > Kernel: arch/x86/boot/bzImage is ready  (#1)
>> >  Building modules, stage 2.
>> >  MODPOST 7 modules
>> > ERROR: "input_ff_create_memless" [drivers/hid/hid-wiimote.ko]
>> > undefined!
>> > make[1]: *** [__modpost] Error 1
>> > make: *** [modules] Error 2
>> >
>> > Signed-off-by: Alec Moskvin <alecmn@gmail.com>
>> > ---
>> >  drivers/hid/Kconfig |    1 +
>> >  1 files changed, 1 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
>> > index 22a4a05..332c22a 100644
>> > --- a/drivers/hid/Kconfig
>> > +++ b/drivers/hid/Kconfig
>> > @@ -620,6 +620,7 @@ config HID_WIIMOTE
>> >        depends on BT_HIDP
>> >        depends on LEDS_CLASS
>> >        select POWER_SUPPLY
>> > +       select INPUT_FF_MEMLESS
>> >        ---help---
>> >        Support for the Nintendo Wii Remote bluetooth device.
>> >
>>
>> This fix is already in Jiri's tree. See here:
>> http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=commitdiff;h=ef6f41157f3864d9bf42671b2ed66062dcafb72e
>>
>> Regards
>> David
>
> I wasn't aware of that. Shouldn't it be pushed to the main tree, then?

It's CC'ed to stable. I think Jiri will push it to linus soon. But
during Christmas some stuff may get lost so ping him if he missed
something ;)

> It's not in 3.2-rc7 (released yesterday), which is why I reported it.
>
> Thanks,
> Alec

Cheers
David
