Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab0CRWKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:10:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42790 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab0CRWKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:10:47 -0400
MIME-Version: 1.0
In-Reply-To: <201003182304.43196.linux@rainbow-software.org>
References: <201003182246.54889.linux@rainbow-software.org>
	 <880c1631003181451r7669428ctee7adc867979bc25@mail.gmail.com>
	 <201003182304.43196.linux@rainbow-software.org>
Date: Thu, 18 Mar 2010 22:10:45 +0000
Message-ID: <880c1631003181510k1850de40r823418a0b921ecee@mail.gmail.com>
Subject: Re: [rt2x00-users] rt2500usb broken since 2.6.29
From: Luis Correia <buga@loide.net>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: users@rt2x00.serialmonkey.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Thu, Mar 18, 2010 at 22:04, Ondrej Zary <linux@rainbow-software.org> wrote:
> On Thursday 18 March 2010 22:51:18 Luis Correia wrote:
>> Hi,
>>
>> On Thu, Mar 18, 2010 at 21:46, Ondrej Zary
> <linux@rainbow-software.org>wrote:
>> > Hello,
>> > rt2500usb is broken since kernel 2.6.29. It has been discussed before but
>> > never solved:
>> > http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=4&t=4834
>> > https://bugzilla.redhat.com/show_bug.cgi?id=484888
>> >
>> > I have Asus WL-167G and it really does not work. Scanning works,
>> > association
>> > too but no packets can be sent (looks like receive works because tcpdump
>> > shows packets from other machines). DHCP fails (No DHCPOFFERS received).
>> >
>> > The problem is caused by this patch:
>> >
>> > rt2x00: Implement HW encryption (rt2500usb)
>> >
>> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit
>> >;h=dddfb478b26e29a2b47f655ec219e743b8111015
>> >
>> > Removing it from 2.6.29 restores the functionality.
>> >
>> > --
>> > Ondrej Zary
>>
>> you can prevent hardware encryption by supplying "nohwcrypt=1" to the
>> driver.
>> (modinfo rt2500usb)
>
> That did not work. Maybe that was because I just unloaded the rt2500usb module
> and loaded it again with nohwcrypt=1 without rebooting the machine. Then I
> removed the HW encryption, recompiled and reloaded and it did not work
> either. It started to work only after reboot.

did you actually remove the usb module and unloaded the module as well?

you then need to load the module with the option, wait one sec and
then plug the device back in.

> Does the HW encryption really work with any rt2500usb hardware? How can I help
> to fix it? Or maybe it should be disabled by default.

I think the HW encription did work in the past, but I'm unsure of the
proper timeline.

Luis Correia
rt2x00 project admin
