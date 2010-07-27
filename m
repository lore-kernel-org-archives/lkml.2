Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0G0Xyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:54:31 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59156 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab0G0XyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:54:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Y5QvgfPtC8WY0ZKOAuSGKn8LmirY/KqP618+RCxAsDd8I2U3Qiw24NNOMWsSF7wEjT
         tu2Ypphbea/vdLeRnu4WfAK05vfFsFN958tPVYyy6CNSl8KYhvQZMnP6IQdgRw7A7nJt
         Tg8IaqNwzcN5I49Vigf6auLwx3GzQ0sM735nw=
MIME-Version: 1.0
Date: Tue, 27 Jul 2010 18:54:24 -0500
Message-ID: <AANLkTi=bbmAH1pL5EBoOKBKMN4bm8ZEpwV1BHYNPB8Ps@mail.gmail.com>
Subject: Question missing menul.lst file
From: Victor Rodriguez <vm.rod25@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have already clone the mainline and follw the steps sugested in
kernelnewbies in order compile the kenel I was working in ubuntu 10.04
 i followed all the instruction in this way

$make menuconfig
$make
#make modules_install
#make install

but then they put really explicit

If you're using Ubuntu, you will need to edit menu.lst instead of grub.conf

I look for in ubuntu documentation for this file and ubuntu establish
in the LucidLynx/ReleaseNotes that the file most be opened by this way

Open /boot/grub/menu.lst with a text editor (e.g., sudo gedit
/boot/grub/menu.lst).

And then save the file, and run sudo update-grub from the commandline.

I have run in file system

$sudo find -name menu.lst and nothing appear

any way i skip the part of open the menu.lst file and just did the
sudo update-grub and for me it works the image of the new kernel is
available after reboot the machine i cehck the kernel version with

$ uname -a and this appear

Linux victor-desktop 2.6.35-rc6+ #1 SMP Tue Jul 27 16:40:26 CDT 2010
i686 GNU/Linux

I don't know if this is a bug in the new kernel release but at least
in the available documentation it is

Any commentary will be appreciated

Thanks

Victor Rodriguez
