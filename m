Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269Ab2CUUig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 16:38:36 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62675 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab2CUUif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 16:38:35 -0400
MIME-Version: 1.0
Date: Wed, 21 Mar 2012 21:38:33 +0100
Message-ID: <CAE7SGk7rJXwjs4pD01e_ZgkoH4UNLAh8JLfX1_gv=q7RXtY5Gw@mail.gmail.com>
Subject: ext2 large block size support - the shocking truth...
From: Risanecek <risanecek@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...at least for me.

Hi,

I'm currently having a disassembled TV in my living room, pictures are
similar to http://www.avforums.com/forums/11185338-post214.html

The TV may or may not run Linux, it definitely has a hard disk that
has three ext2 partitions on it, oh yes and it formats every new HDD
you stick into it by giving it three ext2 partitions. I thought I'd
update the hdd, copy the old content to the new - bigger - one and
finito. Quick, no fuzz. If these Windows guys can do it...

Attached the new and old hard disk to my small linux home server,
running kernel 3.2.9 and tried to mount the partitions.

*boom*

# mount -text2 /dev/sdd2 partiton2
mount: wrong fs type, bad option, bad superblock on /dev/sdd2,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

dmesg

EXT2-fs (sdd2): error: bad blocksize 32768

Seems many DVRs use that kind of "enhanced ext2"...

http://ubuntuforums.org/showthread.php?t=1942682
(german) http://www.knoppixforum.de/knoppix-forum-deutsch/retter-in-der-not/thread4912/gel%C3%B6st-externe-hd-wisi-sathd-receiver-or193hd-bearbeiten.html
...

You know, normally I'd think "Ah what the heck, the TV guys did
something incompatible to ext2 - to hell with them.", but there is
this Windows issue:
http://www.ext2fsd.com/ can cope with it, as can
http://www.diskinternals.com/linux-reader/

Ouch! "To add insult to injury" as https://lkml.org/lkml/2011/4/1/159 says

So do I understand correctly, that to be able to read an ext2
filesystem, having a home server running Linux is the wrong choice
here? That I should install Windows on it with one of the
aforementioned programs to be able to read / copy my TVs ext2 hdds?
Shall I shoot myself right now or will a facepalm do? Or - that's why
I'm here - is there a chance my linux box actually COULD read these
data?

Please advise.

cordially,
 Richard
