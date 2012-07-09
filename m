Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab2GIPwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 11:52:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51004 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab2GIPwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 11:52:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1207091608060.19366@pobox.suse.cz>
References: <1341592324-665-1-git-send-email-yurivkhan@gmail.com>
	<1341726589-5400-1-git-send-email-yurivkhan@gmail.com>
	<alpine.LNX.2.00.1207091608060.19366@pobox.suse.cz>
Date: Mon, 9 Jul 2012 22:52:32 +0700
Message-ID: <CAP_d_8UDAO8u+y8F8JgPn6FZaZHccjH_aPof4n9zTYT+tDhtMw@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] Input: xpad - Handle all variations of Mad Catz
 Beat Pad
From: Yuri Khan <yurivkhan@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 9:08 PM, Jiri Kosina <jkosina@suse.cz> wrote:

>> --- a/drivers/hid/usbhid/hid-quirks.c
>> +++ b/drivers/hid/usbhid/hid-quirks.c
>> +     { USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_BEATPAD, HID_QUIRK_IGNORE },
>
> Please put it in drivers/hid/hid-core.c, hid_ignore_list[] array instead.
> HID_QUIRK_IGNORE is there solely for allowing specification as a module
> parameter.

I knew something was not right as there were no prior HID_QUIRK_IGNORE
entries. Thanks for the guidance, will send a revised patch tomorrow.
