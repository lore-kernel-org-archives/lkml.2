Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab0HPMjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:39:06 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:40575 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753650Ab0HPMjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:39:03 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-fsdevel@vger.kernel.org
Subject: unable to mount a CD - iso9660 bug?
Date: Mon, 16 Aug 2010 14:38:54 +0200
User-Agent: KMail/1.9.10
Cc: Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008161438.57103.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I have a CD that came with Samsung printer that Linux cannot mount but works 
fine in Windows. The CD is physically OK - "dd" made ISO image without any 
problems. This ISO image is unmountable too. When I force the filesystem to 
iso9660, it mounts but no files are visible:

# mount samsung-bad.iso /mnt/tmp -o loop
mount: you must specify the filesystem type
# mount samsung-bad.iso /mnt/tmp -o loop -t iso9660
# ls -la /mnt/tmp
total 6
dr-xr-xr-x  2 root root 2048 Oct 30  2009 .
drwxr-xr-x 15 root root 4096 Sep 26  2006 ..
# df -h /mnt/tmp
Filesystem            Size  Used Avail Use% Mounted on
/dev/loop0            232M  232M     0 100% /mnt/tmp

dmesg shows this:
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A


If anyone can look into this, I can provide a link to the compressed ISO file 
(75MB).

-- 
Ondrej Zary
