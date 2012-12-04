Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab2LDLus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 06:50:48 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57950 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab2LDLuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 06:50:44 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1212041129530.17055@pobox.suse.cz>
References: <1352731379-24683-1-git-send-email-benjamin.tissoires@gmail.com>
	<20121130155650.69407e9f@endymion.delvare>
	<CAN+gG=FjVswyx1W4y6NtbNnBu2AWgZZfxVr0h00ZYujCOz3v7Q@mail.gmail.com>
	<20121203140226.0fede51e@endymion.delvare>
	<CAN+gG=F5jae=UFDR4-zZY-dt6KGE22QgmWiF2RkVvqN0ySX-kQ@mail.gmail.com>
	<alpine.LNX.2.00.1212041129530.17055@pobox.suse.cz>
Date: Tue, 4 Dec 2012 12:50:39 +0100
Message-ID: <CAN+gG=G+ymEdfAf3Ub6n8ErhPBz1BB3XYyEPixz9sWbNeRnPDQ@mail.gmail.com>
Subject: Re: [PATCH v3] i2c-hid: introduce HID over i2c specification implementation
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jean Delvare <khali@linux-fr.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, fabien.andre@gmail.com,
        scott.liu@emc.com.tw, JJ Ding <jj_ding@emc.com.tw>,
        Jiri Slaby <jslaby@suse.cz>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 4, 2012 at 11:31 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 3 Dec 2012, Benjamin Tissoires wrote:
>
>> >> I know that it already have been used by one Nvidia team and by Elan
>> >> for internal tests. So I don't know if it's possible to change it now
>> >> (though it's not a big deal).
>> >
>> > Yes it is possible, as long as the code isn't in Linus' tree (and I'd
>> > even say: as long as it is not in any kernel released by Linus.)
>> > Whoever is already using your driver will have to adjust their code.
>> > They'll certainly want to anyway, in order to get the bug fixes.
>> >
>> >> Anyway, "hid" is a little weird to me (but this is because I started
>> >> hacking the kernel from there), as it's really short and does not
>> >> contain i2c :)
>> >
>> > This is exactly my point: no other i2c client (to my knowledge) has
>> > "i2c" in its name, because it is redundant.
>> >
>> > I would agree that this is kind of a special case as this is a generic
>> > driver and not a device-specific driver. I would still prefer "hid" but
>> > if you don't feel like changing it, I guess I can live with that.
>>
>> Ok, I'll change the name.
>> My concerns were just because from my point of view, "hid" refers to
>> the core implementation. But for OEMs, they need to declare a "hid"
>> device, so it makes sense. Anyway, when I'll be able to get my hand on
>> an ACPI 5 device with hid over i2c, I'll be able to write the missing
>> autoloading code, and this name will be only used by a small part of
>> OEMs (I hope).
>
> If you are going to change the name, please either send me the patch
> before merge window for 3.8 opens, or explicitly ask me not to include
> this driver in pull request that goes to Linus yet.

Sure, I intend to send some patches today (with the change of the name
included). I'll send the patch related to the name in the first
position so that you can safely pick it up even if you are not
satisfied with the other changes.

Thanks,
Benjamin

>
> Once the driver is in Linus' tree, I'd rather not change the name.
>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
