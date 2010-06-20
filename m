Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab0FTFfr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 01:35:47 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56109 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab0FTFfo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 01:35:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wHks4xetc+ogEfuejbGPsFUaRl7Rd1PJLmPHpa8/0I+aw5cVhfzzsZ4uW0M1LYc49p
         ZdhS5LKrWSD/zBgrvZZARCBhw8Bg1OQrqyTMYMvu2J3MRAXxpqntRZahWRh2/AaXvyLh
         zu2KiBbx7nM092tS9j3z/ViqX9l5VL8r3QJrQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTinq_3P-QrTqsEdtyMbBtc9EXhahclER_4s5_Kx2@mail.gmail.com>
References: <AANLkTinq_3P-QrTqsEdtyMbBtc9EXhahclER_4s5_Kx2@mail.gmail.com>
Date: Sat, 19 Jun 2010 22:35:43 -0700
Message-ID: <AANLkTikExwM_LBUw_-z2eimO96Dxs_fNfAM4jlftXyHM@mail.gmail.com>
Subject: Re: Wacom based devices and the mt kernel protocol.
From: Ping Cheng <pinglinux@gmail.com>
To: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
       Chase Douglas <chase.douglas@canonical.com>,
       Rafi Rubin <rafi@seas.upenn.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mohamed,

I am glad that you've initiated this email thread. Otherwise, I would
have to find a proper way to explain the current status of Wacom MT
support. Please see my comments inline.

Thank you,

Ping

On Fri, Jun 18, 2010 at 4:20 AM, Mohamed Ikbel Boulabiar
<boulabiar@gmail.com> wrote:
> Hi,
>
> Now we can find many multitouch devices based on wacom Wacom panel/digitizer
> Bamboo Pen&Touch, HP tm2, Fujitsu LifeBook T4410 & T4310, etc...
>
> it seems that these devices are supported in some way in Linux Kernel,
> but I want to know if they are compliant with the MT Linux protocol.

As most of you know, the current Wacom two finger touch devices have
been supported on Linux since last Oct.  However, they are not
supported with the current in-kernel MT protocol, aka, MT type A
protocol.

I know you would ask me why. The reason is simple: it doesn't support
the Wacom case - finger tracking.  If you wonder why I don't work with
the other developers to support Wacom MT case, I can assure you that I
am working with them. We will support Wacom MT devices once the
appropriate protocol is available.

> N-Trig based devices and Stantum ones are the most compliant,

That's fair since they don't need to track the fingers.

> so Wacom situation needs to be clarified specially considering they are HID
> devices (meaning similar to the others devices which respect the
> protocol).

Well, it is not a pure HID issue.  It is more of how we want to
support MT on Linux issue.

> This impact very much the decision of a Linux user wanting to buy wacom mt device.

I think end users have already got the Linux support from Wacom.  Can
you share the specific issues that are preventing Linux end users from
buying a Wacom MT devices? If I didn't misunderstand your point here,
you are talking about Linux users, not Linux developers/hackers,
right?

> Ping can you clarifie the situation of wacom based devices ?

What else do you need me to clarify? I am all ears and I am ready to
clarify any thing that puzzles you.

Ping

> Thanks,
>
> ik.
>
> On Tue, Jun 15, 2010 at 7:01 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>>
>> g number of intelligent multi-contact and
>> multi-user devices, the need to send digested, filtered information
>> from a set of different sources within the same device is imminent.
>> This patch adds the concept of slots to the MT protocol. The slots
>> enumerate a set of identified sources, such that all MT events
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
