Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab1J0I3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 04:29:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64028 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab1J0I3U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 04:29:20 -0400
MIME-Version: 1.0
In-Reply-To: <42295.128.173.192.90.1319633510.squirrel@webmail.tuffmail.net>
References: <42295.128.173.192.90.1319633510.squirrel@webmail.tuffmail.net>
Date: Thu, 27 Oct 2011 10:29:19 +0200
Message-ID: <CAKWSe6BMHujJNA6rMe5rNC79mKBePZZdRY_NtYfCuLw-MCm6Zg@mail.gmail.com>
Subject: Re: initrd image size of 3.1.0 kernel
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Brad Tilley <brad@16systems.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 2:51 PM, Brad Tilley <brad@16systems.com> wrote:
> I built a vanilla stable kernel using the most recent 3.1.0 stable source.
> I built it like this:
>
> make silentoldconfig
> make deb-pkg
>
> The kernel boots and runs fine. However, the size (greater than 100 MB) of
> the initrd image surprised me. Doing the same sort of build for a 3.0.x
> kenerl produces a much smaller image:
>
> -rw-r--r--  1 root root  12M Sep  6 11:57 initrd.img-3.0.4
> -rw-r--r--  1 root root 107M Oct 26 08:03 initrd.img-3.1.0
>
> I only want to point this out. Perhaps I missed something in the
> documentation that explains the size difference, or something in my old
> config or toolset caused it. Here are some versions installed on my
> system:
>
> gcc (Debian 4.4.5-8) 4.4.5
> GNU Make 3.81
> GNU ld (GNU Binutils for Debian) 2.20.1-system.20100303
> fdformat (util-linux-ng 2.17.2)
> module-init-tools 3.12
> grub-install (GRUB) 1.98+20100804-14+squeeze1
>
> I'm not subscribed, so please CC if you wish for me to see the replies or
> if you would like more info.
>
> If this larger size is normal (not an error on my part) then /boot sizes
> will need to grow to accommodate this.

Fedora 15 uses initramfs and doesn't show the issue:

[root@duff ~]# ls -ltr /boot/initramfs-*
-rw-r--r--. 1 root root  8675175 Jul 22 13:13 /boot/initramfs-3.0.0.img
-rw-r--r--. 1 root root  8747813 Aug  8 22:56 /boot/initramfs-3.1.0-rc1.img
-rw-r--r--. 1 root root  8747318 Aug 13 19:40 /boot/initramfs-3.1.0-rc1-git7.img
-rw-r--r--. 1 root root  8749876 Aug 30 11:09 /boot/initramfs-3.1.0-rc4-git1.img
-rw-r--r--. 1 root root  8750005 Sep  2 10:48 /boot/initramfs-3.1.0-rc4-git2.img
-rw-r--r--. 1 root root  8940095 Oct 26 11:26 /boot/initramfs-3.1.0.img

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
