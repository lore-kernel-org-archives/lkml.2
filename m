Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0G2IvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 04:51:20 -0400
Received: from laas.laas.fr ([140.93.0.15]:43098 "EHLO laas.laas.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab0G2IvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 04:51:19 -0400
X-Greylist: delayed 2140 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jul 2010 04:51:19 EDT
Date: Thu, 29 Jul 2010 10:16:26 +0200
From: Fernand LONE SANG <fernand.lone-sang@laas.fr>
To: linux-kernel@vger.kernel.org
Subject: i2cdetect outputs on Intel x58 chipsets wanted
Message-ID: <20100729081626.GE4966@laas.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone.

My apology for multiple reception of this mail. As i did not get much
answer from the linux-i2c mailing list, i try this one which is
bigger. I am probably off-topic so feel free to skip to the next
thread ;)

I am currently trying to reach a SMBus slave component located in the
I/O Hub (IOH) on Intel x58 chipsets. According to Intel
specifications, this component enable server manageability. As my
motherboard (DX58SO E29331-503) does not seem to have this component
and as I did not manage to get in touch with an Intel technician for
help, i'm looking for some kind people, with an Intel x58 chipset, who
can send me by email their outputs from the i2cdectect tool so i can
identify the motherboard version that have this component.

For ones who can help me, you should first load the i2c-dev and
i2c-i801 kernel modules:
      
  $ sudo modprobe i2c-dev
  $ sudo modprobe i2c-i801

Then, you should install i2c-tools to get i2cdetect. e.g., for debian
based distribution:

  $ sudo apt-get install i2c-tools

Now i would like you to run "i2cdetect -l" to identify the i2c adapter
available on your computer and then run i2cdetect on the Intel i801
adapter. For example:

  $ sudo i2cdetect -l
  i2c-0	   i2c	    nouveau-0000:02:00.0-0	  I2C adapter
  i2c-1	   i2c      nouveau-0000:02:00.0-1        I2C adapter
  i2c-2	   smbus    SMBus I801 adapter at 3000    SMBus adapter

  $ sudo i2cdetect 2
  ...

At this stage, a warning message will appear stating that this
manipulation can confuse your i2c bus and it will ask you whether to
continue or not. Type 'Yes'. Then, it will output some numbers on the
screen. It is this output what i need. Additionnally, if you can send
me the output of dmidecode so i can identify the exact motherboard
model you have, it will be perfect.

  $ sudo i2cdetect 2 > i2cdetect.out
  $ sudo dmidecode > dmidecode.out

Thanks everyone for your help. I really appreciate. Sorry again for
being off-topic.

--
Fernand LONE SANG
