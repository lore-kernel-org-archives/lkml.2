Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab1LTD0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 22:26:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34270 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1LTD0x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 22:26:53 -0500
MIME-Version: 1.0
In-Reply-To: <20111219204932.GA13165@home.goodmis.org>
References: <CAJm7N86LJeiiarRjQBDKGDK5=qxjiKHDUiDYkEbhPejP7VBqiQ@mail.gmail.com>
	<20111219204932.GA13165@home.goodmis.org>
Date: Tue, 20 Dec 2011 11:26:52 +0800
Message-ID: <CAJm7N87tqTuERV-JoUFf7mdyGroikbVkQ+2Hc3Mf0_SN3gs=Mw@mail.gmail.com>
Subject: Re: kernel.org/pub/ was re-organized recently?
From: Rijndael Cosque <rijcos@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, "J.H." <warthog9@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 4:49 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, Dec 19, 2011 at 10:51:14PM +0800, Rijndael Cosque wrote:
>> Hi all,
>> I'm sorry if I report this below issue in the wrong mailing list...
>
> This is as good of a list as any. But since there are over 600 emails a
> day on this list, you can easily be lost in the noise. Luckily for you,
> I got bored while waiting for my test box to reboot and decided to
> browse LKML where your subject line intgrigued my curiostity.
Yes, I'm lucky enough!  :-)


>> Recently when I tried to wget the following packages, I got a HTTP 404
>> error (not found):
>>
>> http://kernel.org/pub/linux/kernel/people/jsipek/guilt/guilt-0.33.tar.gz
>> http://kernel.org/pub/linux/libs/pam/library/Linux-PAM-1.1.4.tar.bz2
>> http://kernel.org/pub/linux/bluetooth/bluez-hcidump-2.1.tar.gz
>> http://kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.22.tar.bz2
>> http://kernel.org/pub/software/utils/pciutils/pciutils-3.1.7.tar.bz2
>> http://kernel.org/pub/linux/utils/usb/usbutils/usbutils-0.91.tar.gz
>> http://kernel.org/pub/linux/utils/kernel/module-init-tools/module-init-tools-3.16.tar.bz2
>> http://kernel.org/pub/linux/utils/util-linux-ng/v2.19/util-linux-2.19.1.tar.bz2
>> http://kernel.org/pub/linux/bluetooth/bluez-4.96.tar.gz
>> http://kernel.org/pub/linux/utils/kernel/hotplug/udev-164.tar.gz
>> http://kernel.org/pub/linux/utils/kernel/kexec/kexec-tools-2.0.2.tar.gz
>> http://kernel.org/pub/linux/network/ofono/ofono-0.50.tar.bz2
>> http://kernel.org/pub/linux/utils/kernel/pcmcia/pcmciautils-018.tar.bz2
>
> Yep, they aint there anymore.
>
>>
>> I'm sure I could wget them before.
>> Can somebody point to me what happened to the packages? Where were
>> they moved to?
>
> I don't know where they are now. Probably somewhere on the developers
> computers that created them.
>
> Here's the issue. You may want to read up on what happened recently with
> kernel.org:
>
>  http://lwn.net/Articles/457142/
>
> And you can get a lot more info here:
>
>  http://lmgtfy.com/?q=kernel.org+hacked
>
> To sum it up in a nutshell; kernel.org has been wiped clean,
> reinstalled, and all the content on there today has been loaded up by
> the original developers as they saw fit to put it back. Not all the
> developers that had access to kernel.org before has access today. The
> above tools may comeback slowly. If you need them, you might want to
> find the developers that created the tools and ask them where they are.
>
> Sorry I can't be of more help. Good luck in finding what you need.
>
Hi Steve,
Thank so much for the detailed explanation!!!
I actually heard about the hacking incident happened in a few months ago.
I just didn't notice not everything had been restored already. :-(


Thanks,
-- Dexuan
