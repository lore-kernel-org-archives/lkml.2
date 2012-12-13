Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab2LMSWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 13:22:18 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61587 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab2LMSWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 13:22:16 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1212131307250.1415-100000@iolanthe.rowland.org>
References: <CANc+2y5pJzda_Rafunn9rFZSgH_Dyq5+rer3rss1=5E7QxqZ6Q@mail.gmail.com>
	<Pine.LNX.4.44L0.1212131307250.1415-100000@iolanthe.rowland.org>
Date: Thu, 13 Dec 2012 23:52:14 +0530
Message-ID: <CANc+2y6yRSHXvnftmvhqdMafn-v3b2_28prx0DHQ+MA=9rMq8A@mail.gmail.com>
Subject: Re: Fwd: Safely remove option shows with Micro SD Card connected to
 Linux through an Android phone
From: prasannatsmkumar <prasannatsmkumar@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        nautilus-list@gnome.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 11:40 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 13 Dec 2012, prasannatsmkumar wrote:
>
>> On Wed, Dec 12, 2012 at 2:07 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> > STOP UNIT means spin down the disk or eject the disc.  Since your phone
>> > doesn't have a disk drive or an optical disc, no wonder this step
>> > failed.
>>
>> Yes of course it does not have a optical disc or disk drive. But I
>> thought if there is no such thing nautilus should not try to spin
>> down. Linux kernel has nothing to do with this problem though.
>
> Right.  Bear in mind that nautilus may not have any way of finding out
> whether the device has removable media, other than requesting for the
> media to be ejected.  But if it doesn't know then failure of the
> request shouldn't be reported as an error.

Is kernel not exposing this information? The other OS shows "Eject"
for the android device and for other pen drive I get a "safely remove"
option - stated this assuming the options in nautilus and the other OS
mean the same.

Thanks,
PrasannaKumar
