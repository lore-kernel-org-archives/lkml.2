Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905Ab2F1KIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 06:08:09 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:36819 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932777Ab2F1KIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:08:05 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1206281030070.17549@pobox.suse.cz>
References: <1340109594-10732-1-git-send-email-benjamin.tissoires@gmail.com>
	<alpine.LNX.2.00.1206281030070.17549@pobox.suse.cz>
Date: Thu, 28 Jun 2012 12:08:04 +0200
Message-ID: <CAN+gG=GRO3PXK1QF4rUq49Z-7gXd6VDz=cbTNNmJBP6NLcgCKQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] HID: hid-multitouch: fix input mode feature command
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Thanks a lot for that.
My apologies. I didn't thanked Henrik and commented his review. So
thank you Henrik. (the "break" here is not an optimisation as
field->maxusage may be greater than the real report count).

I'm currently quite overloaded with the hid over i2c bus, and I'm
getting some very goods results. I'm stuck with the acpi part, but the
rest of it is working pretty good for a draft. I'll keep you inform
soon.

Cheers,
Benjamin

On Thu, Jun 28, 2012 at 10:31 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 19 Jun 2012, benjamin.tissoires wrote:
>
>> From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>>
>> Zytronic panels shows a new way of setting the Input Mode feature.
>> This feature is put in the second usage in the HID feature, instead
>> of the first, as the majority of the multitouch devices.
>>
>> This patch adds a detection step when the feature is presented to know
>> where the feature is located in the report. We can then trigger the right
>> command to the device. This removes the magic number "0" in the function
>> mt_set_input_mode.
>
> I have applied 1/3 and 3/3. For 2/3, Henrik raised concern which I'd like
> to have resolved first.
>
> Thanks!
>
> --
> Jiri Kosina
> SUSE Labs
