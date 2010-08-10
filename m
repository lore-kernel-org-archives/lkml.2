Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab0HJUgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 16:36:40 -0400
Received: from vs244178.vserver.de ([62.75.244.178]:45550 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757925Ab0HJUgi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 16:36:38 -0400
Date: Tue, 10 Aug 2010 22:36:35 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <618241473.20100810223635@eikelenboom.it>
To: Joerg Roedel <joro@8bytes.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [2.6.35] AMD-Vi: Enabling IOMMU at 0000:00:00.2 cap 0x40  BUG: unable to handle kernel NULL pointer dereference at 0000000000000198
In-Reply-To: <20100810202839.GS23755@8bytes.org>
References: <1154489525.20100810164850@eikelenboom.it> <20100810162606.GQ23755@8bytes.org> <419601760.20100810185745@eikelenboom.it> <20100810180122.GR23755@8bytes.org> <1609756756.20100810200514@eikelenboom.it> <20100810202839.GS23755@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joerg,

Errr which seperate usb controller ? .. it has actually:
- 1 pci-e usb 2.0 controller
- 2 pci-e usb 3.0 controller (one of which includes a sata controller as well)

(apart from the onboard stuff)

--
Sander


Tuesday, August 10, 2010, 10:28:39 PM, you wrote:

> On Tue, Aug 10, 2010 at 08:05:14PM +0200, Sander Eikelenboom wrote:
>> Could you also provide a perhaps more specific message what is wrong
>> with the bios, that i could forward to MSI, in the hope it will reach
>> the bios engineers someday ? :-)

> Lets first prove that my theory is right before contacting MSI directly.
> Can you try the attached patch? it should fix the boot-crash. When the
> system booted successfully please try some USB device (make sure it uses
> the seperate usb-controler, I guess the seperate device is responsible
> for USB 3, so try to plug a device into one of your USB 3 ports).
> If you finished that please send me whether it worked or not and the
> full dmesg output of the system.

>         Joerg




-- 
Best regards,
 Sander                            mailto:linux@eikelenboom.it

