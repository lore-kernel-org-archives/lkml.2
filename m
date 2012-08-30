Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2H3P17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 11:27:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36267 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab2H3P14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 11:27:56 -0400
MIME-Version: 1.0
In-Reply-To: <9058FA5F-3F4F-495D-AC5F-4C6C05EC0FC5@ibink.com>
References: <CALCETrW-LFzcHYgx=thQiuTfU8RdRBrtXwE7QboWpNrjz4An4A@mail.gmail.com>
 <9058FA5F-3F4F-495D-AC5F-4C6C05EC0FC5@ibink.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 30 Aug 2012 08:27:35 -0700
Message-ID: <CALCETrUsnxLpv0AuM0792QEFs_dRwCUZz_yxQ3ZObOHXV1AQVw@mail.gmail.com>
Subject: Re: Which disk is ata4?
To: Tim Nufire <linux_ide_tim@ibink.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 8:15 AM, Tim Nufire <linux_ide_tim@ibink.com> wrote:
>
> I'm not sure if there is a better way, but on Debian 5 "Squeeze" I look at the contents of the directory /dev/disk/by-path/
>
> ls -l /dev/disk/by-path/
> total 0
> lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:00:1f.2-scsi-0:0:0:0 -> ../../sdae
> lrwxrwxrwx 1 root root 11 2012-08-08 14:42 pci-0000:00:1f.2-scsi-0:0:0:0-part1 -> ../../sdae1
> lrwxrwxrwx 1 root root 11 2012-08-08 14:42 pci-0000:00:1f.2-scsi-0:0:0:0-part2 -> ../../sdae2
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-0:0:0:0 -> ../../sda
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-0:1:0:0 -> ../../sdb
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-0:2:0:0 -> ../../sdc
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-0:3:0:0 -> ../../sdd
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-0:4:0:0 -> ../../sde
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-3:0:0:0 -> ../../sdf
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-3:1:0:0 -> ../../sdg
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-3:2:0:0 -> ../../sdh
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-3:3:0:0 -> ../../sdi
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-3:4:0:0 -> ../../sdj
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-4:0:0:0 -> ../../sdk
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-4:1:0:0 -> ../../sdl
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-4:2:0:0 -> ../../sdm
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-4:3:0:0 -> ../../sdn
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-4:4:0:0 -> ../../sdo
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-0:0:0:0 -> ../../sdp
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-0:1:0:0 -> ../../sdq
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-0:2:0:0 -> ../../sdr
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-0:3:0:0 -> ../../sds
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-0:4:0:0 -> ../../sdt
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-2:0:0:0 -> ../../sdu
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-2:1:0:0 -> ../../sdv
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-2:2:0:0 -> ../../sdw
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-2:3:0:0 -> ../../sdx
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-2:4:0:0 -> ../../sdy
> lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-3:0:0:0 -> ../../sdz
> lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:04:04.0-scsi-3:1:0:0 -> ../../sdaa
> lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:04:04.0-scsi-3:2:0:0 -> ../../sdab
> lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:04:04.0-scsi-3:3:0:0 -> ../../sdac
> lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:04:04.0-scsi-3:4:0:0 -> ../../sdad
> lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-0:0:0:0 -> ../../sdaf
> lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-0:1:0:0 -> ../../sdag
> lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-0:2:0:0 -> ../../sdah
> lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-0:3:0:0 -> ../../sdai
> lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-0:4:0:0 -> ../../sdaj
> lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-2:0:0:0 -> ../../sdak
> lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-2:1:0:0 -> ../../sdal
> lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-2:2:0:0 -> ../../sdam
> lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-2:3:0:0 -> ../../sdan
> lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-2:4:0:0 -> ../../sdao
> lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-3:0:0:0 -> ../../sdap
> lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-3:1:0:0 -> ../../sdaq
> lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-3:2:0:0 -> ../../sdar
> lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-3:3:0:0 -> ../../sdas
> lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-3:4:0:0 -> ../../sdat
>
> The SCSI ids are one less than ATA ids because they start at 0 rather than 1. So, ata4.00 is the same as scsi-3:0:0:0. On my system this means that ata4.00 is sdap.

...which presumably stops working as soon as there's a non-ATA SCSI
device in the system.  (It worked for me, I think, but there really
ought to be a generic solution.)

Again, what's apparently missing is a map between ata
ports/links/devices and scsi hosts/targets/devices.

--Andy
