Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab0IKNe1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 09:34:27 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:37176 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab0IKNe0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 09:34:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <19595.34143.859553.402816@pilspetsen.it.uu.se>
Date: Sat, 11 Sep 2010 15:34:23 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How to determine the information about SATA controller
In-Reply-To: <AANLkTinQVQsjxJLpZQiP5V56o7quGPY6G0ZOnvwPAKbx@mail.gmail.com>
References: <AANLkTimMxQXxC354V=qVOrdUYFSrpJ-RZeKJfQEx0KPN@mail.gmail.com>
	<19595.23873.90306.656565@pilspetsen.it.uu.se>
	<AANLkTinQVQsjxJLpZQiP5V56o7quGPY6G0ZOnvwPAKbx@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput writes:
 > >  > No root device found.
 > >  > Boot has failed, sleeping forever
 > >  >
 > >  > I am trying to determine the information about the SATA controller so
 > >  > that I can choose the appropriate controller for SATA in kernel
 > >  > config. I am not able to figure out the SATA information from above
 > >  > dmesg and lsmod. How can I do so.
 > >
 > > In your working dmesg the disks are controlled by ata_piix,
 > > but you've disabled CONFIG_ATA_PIIX in the config you're trying.
 > > So it's not surprising that you can't boot.
 > >
 > > 1) re-enable CONFIG_ATA_PIIX and disable CONFIG_IDE
 > 
 > I have enabled CONFIG_ATA_PIIX
 > and disabled CONFIG_IDE
 > 
 > but still getting same error :
 > 
 > No root device found.
 > Boot has failed, sleeping forever
 > 
 > Am I missing some more options.
 > 
 > > or
 > > 2) go into the bios and change the option that says whether to run
 > >   the ATA controller in legacy/compatible mode or enhanced/ahci mode,
 > >   you want ahci mode
 > >
 > 
 > In my case, BIOS options are enhanced / legacy / disabled. I tried all
 > but of no use. So I am using enhanced to boot Fedora 13 kernel.

We need to see the complete kernel messages from a failed boot to
determine the root cause of that missing root device failure.

I suggest hooking up a null-modem serial cable to a second machine
and run minicom on that one to capture boot messages, but there may
be other ways to capture boot messages: netconsole? firewire?
