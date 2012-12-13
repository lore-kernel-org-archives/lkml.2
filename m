Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab2LMQlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:41:07 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38689 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab2LMQlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:41:05 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1212111530250.1180-100000@iolanthe.rowland.org>
References: <CANc+2y50-AYJcJgeQ8JHJiMjwxg=tbkQ2HQR4=ZZsEthKiWXgw@mail.gmail.com>
	<Pine.LNX.4.44L0.1212111530250.1180-100000@iolanthe.rowland.org>
Date: Thu, 13 Dec 2012 22:11:03 +0530
Message-ID: <CANc+2y5pJzda_Rafunn9rFZSgH_Dyq5+rer3rss1=5E7QxqZ6Q@mail.gmail.com>
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

On Wed, Dec 12, 2012 at 2:07 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> STOP UNIT means spin down the disk or eject the disc.  Since your phone
> doesn't have a disk drive or an optical disc, no wonder this step
> failed.

Yes of course it does not have a optical disc or disk drive. But I
thought if there is no such thing nautilus should not try to spin
down. Linux kernel has nothing to do with this problem though.

>
> No, neither option cuts power.  The main difference is that "safely
> remove" disables the USB connection, so that if the device has an "okay
> to unplug now" light, the light will turn on.

I have seen lights going off in my pen drive, so naturally as an user
I assumed that nautilus request the kernel to cut down the power and
kernel did that. After choosing "Safely Remove" option my device node
(/dev/sdb or whatever) still exists?

>
> You probably should get in touch with the people who maintain the
> Nautilus program if you want to know why it does something.

Yeah sure. Nautilus people are in this list. I will communicate with them.

Thanks and Regards,
PrasannaKumar
