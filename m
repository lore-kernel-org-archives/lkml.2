Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab1FDCqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 22:46:32 -0400
Received: from mail001.aei.ca ([206.123.6.130]:36251 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab1FDCqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 22:46:31 -0400
From: Ed Tomlinson <edt@aei.ca>
To: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Fwd: Re: Linux 2.6.39.1
Date: Fri, 3 Jun 2011 22:46:25 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.39.1-crc+; KDE/4.6.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106032246.25979.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 June 2011 20:38:35 you wrote:
> I'm announcing the release of the 2.6.39.1 kernel.
> 
> All users of the 2.6.39 kernel series must upgrade.
> 
> The updated 2.6.39.y git tree can be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.39.y.git
> and can be browsed at the normal kernel.org git web browser:
>         http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.39.y.git;a=summary
> 

Greg,

Just updated to 39.1 and it breaks my magicmouse

[  107.360715] input: Apple Wireless Mouse as /devices/pci0000:00/0000:00:13.2/usb2/2-4/2-4.4/2-4.4:1.0/bluetooth/hci0/hci0:21/input8
[  107.376797] magicmouse 0005:05AC:030D.0005: input,hidraw3: BLUETOOTH HID v0.84 Mouse [Apple Wireless Mouse] on 00:02:72:20:20:1D
[  107.423387] magicmouse 0005:05AC:030D.0005: unable to request touch data (2)
[  107.451216] magicmouse: probe of 0005:05AC:030D.0005 failed with error 2

and the magicmouse is dead.

reverting 23746a66d7d9e73402c68ef00d708796b97ebd72

makes it work as before.

Thanks,

Ed Tomlinson
