Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1J0GZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 02:25:36 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61876 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab1J0GZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 02:25:35 -0400
MIME-Version: 1.0
X-Originating-IP: [117.254.13.84]
Date: Thu, 27 Oct 2011 11:55:33 +0530
Message-ID: <CAAhSdy0G_vwyEJkO6_wCsmimiCpB9NWyTjdNBRYrSvNxxwpyHw@mail.gmail.com>
Subject: [ANNOUNCE] (offtopic) Xvisor: eXtensible Versatile hypervISOR
From: Anup Patel <anup@brainfault.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Announcing Xvisor v0.1.0, a new open source bare-metal hypervisor, which aims
towards providing virtualization solution, which is light-weight, portable,
and flexible with small memory foot print and less virtualization overhead.
It is distributed under GNU Public License (GPLv2).

Xvisor has most of the features expected from a modern full fledged hypervisor:
 - Tree based configuration
 - Tickless and high resolution timekeeping
 - Threading framework
 - Device driver framework
 - CPU virtualization
 - Address Space virtualization
 - Device emulation framework
 - Serial port virtualization
 - Managment terminal

Xvisor is currently being ported for two architectures: ARM and MIPS. The
development & testing is being done using QEMU (0.14.xx or higher).

Xvisor ARM is able to boot multiple unmodified Linux-2.6.30.10 or Linux-3.0.4
guest with a fairly interactive and smooth Busybox 0.19.2 console. Currently
supported host for Xvisor ARM is Realview-PB-A8 Board emulated by QEMU. It is
also being ported to real hardware, specifically Beagle Board.

Please try out our Xivsor ARM demo on QEMU (0.14.xx or higher). To download
the demo tarball visit the link below:
https://docs.google.com/a/brainfault.org/leaf?id=0B0ABS_s60oP_OGE2MDA0MWYtNDUxOS00YWZkLTllMmMtN2M5MmE1ZGM0NDky&hl=en_GB

Xvisor MIPS is still a work in progress and will be announced very soon.

Xvisor is currently hosted on Github, to clone or download source code please
visit following links:
Mainline: https://github.com/xvisor/xvisor
ARM Development: https://github.com/avpatel/xvisor-arm
MIPS Development: https://github.com/hschauhan/xvisor-mips

Our developer mailing list is xvisor-devel[at]googlegroups[dot]com, please feel
free to post your queries or join our development mailing list.
