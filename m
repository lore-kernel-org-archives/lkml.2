Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab2CJUUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 15:20:15 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55407 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab2CJUUM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 15:20:12 -0500
MIME-Version: 1.0
In-Reply-To: <20120310195105.6d301bd5@pyramind.ukuu.org.uk>
References: <CAPweEDz+seEGbAtE48NfPon66jqvb0sNSMcnC-LnXvmVbF+sbA@mail.gmail.com>
	<CAPweEDysGTCNp+6SCCpzBorwn5ZczNNgV0E+mBLe0FwfE=3Wqw@mail.gmail.com>
	<20120310130055.5bd5263a@pyramind.ukuu.org.uk>
	<CAPweEDx3ktAgz9vdM+E-c5YZGrbBMbX4TOy+QUHV3mRM28oWRw@mail.gmail.com>
	<20120310195105.6d301bd5@pyramind.ukuu.org.uk>
Date: Sat, 10 Mar 2012 20:20:11 +0000
Message-ID: <CAPweEDyk+hshsUfUpSPq9ToNkquwDD0OjYUJknaZGLfKf0U1zw@mail.gmail.com>
Subject: Re: [advice sought] EOMA68 kernel support
From: lkcl luke <luke.leighton@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 7:51 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>>  of particular concern is that a CPU card could be running on (small!)
>> backup battery / supercapacitor whilst being hot-swapped, and thus
>> that means that the LCD module (drivers/eoma68/lcd.ko?) would need to
>> be loaded and unloaded from userspace (udev).  that's not going to be
>> a problem, is it?  i may just be imagining skeletons in the closet,
>> here.
>
> Your device tree describes devices. Your bus creates them when you
> hotplug and it removes them when you hot unplug. The rest is the drivers
> problem to behave properly, and refcount right.


>>  * it's the purposes to which the 16 GPIOs can be put that will be
>> radically different from one I/O board to the next.  GPIO 0 could be
>> "powerup for WIFI" on one I/O board, but "lid open/shut switch" on
>> another.
>
> It's "GPIO 0 of card X" and providing you remember that, watch your
> refcounting and don't remap a new device over the address space of an old
> one during a hotplug you should be fine.

 allright.  thanks alan.  that's clear.

honest opinion sought: is this something that would keep a (good) gsoc
student occupied full-time?  you or i could complete it in a week, 2
weeks, whatever, but i'm concerned that a gsoc student would go "um is
that it??"

yes we'll have by then one or two reference platforms, but that's not
going to be rocket science to get the device drivers for them
up-and-running [non-eoma-compliant].

i guess i'm talking myself out of the proposal, am looking for advocates :)

l.
