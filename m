Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab0G1DBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 23:01:41 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37629 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab0G1DBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 23:01:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r/K1/dhFFzY9o57bzk8GrR+oLdkcJyPdlBSztZiFFlzaitBncBEXCy50Y0GtdFD3um
         hbt0cWbH0IU3teKvlhvEJ4ehEtulcqD1a0eBtvg5Y1MEMHuv9Uwjcibs9808sTC0zgxG
         ZazfJhGY+/AVBMQQgNg++9lQDwMLA1xkELguU=
Date: Wed, 28 Jul 2010 11:05:46 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Victor Rodriguez <vm.rod25@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question missing menul.lst file
Message-ID: <20100728030546.GA5161@cr0.nay.redhat.com>
References: <AANLkTi=bbmAH1pL5EBoOKBKMN4bm8ZEpwV1BHYNPB8Ps@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=bbmAH1pL5EBoOKBKMN4bm8ZEpwV1BHYNPB8Ps@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 06:54:24PM -0500, Victor Rodriguez wrote:
>I have already clone the mainline and follw the steps sugested in
>kernelnewbies in order compile the kenel I was working in ubuntu 10.04
> i followed all the instruction in this way
>
>$make menuconfig
>$make
>#make modules_install
>#make install
>
>but then they put really explicit
>
>If you're using Ubuntu, you will need to edit menu.lst instead of grub.conf
>
>I look for in ubuntu documentation for this file and ubuntu establish
>in the LucidLynx/ReleaseNotes that the file most be opened by this way
>
>Open /boot/grub/menu.lst with a text editor (e.g., sudo gedit
>/boot/grub/menu.lst).
>
>And then save the file, and run sudo update-grub from the commandline.
>
>I have run in file system
>
>$sudo find -name menu.lst and nothing appear
>
>any way i skip the part of open the menu.lst file and just did the
>sudo update-grub and for me it works the image of the new kernel is
>available after reboot the machine i cehck the kernel version with
>
>$ uname -a and this appear
>
>Linux victor-desktop 2.6.35-rc6+ #1 SMP Tue Jul 27 16:40:26 CDT 2010
>i686 GNU/Linux
>
>I don't know if this is a bug in the new kernel release but at least
>in the available documentation it is
>

No, it is the distribution's work to make the kernel installed
correctly in grub.conf or menu.lst. Distribution has to provide
a correct INSTALLKERNEL.

Thanks.
