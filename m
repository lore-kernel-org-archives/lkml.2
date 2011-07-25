Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364Ab1GYMPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:15:43 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:43698 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1GYMPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:15:38 -0400
MIME-Version: 1.0
Date: Mon, 25 Jul 2011 13:15:36 +0100
Message-ID: <CAPweEDyUJZ8ggm0zhMquKNM6Kd-ejjUXrCMR3TnJngukSHAFkw@mail.gmail.com>
Subject: corrupted ext4 1000gb filesystem (2.6.32, debian stable)
From: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

folks, hi,

i set up a 1000gb RAID1 mirrored filesystem, possibly in a foolish way
(multiple external USB drives) and had not added a fsck check to the
script which dynamically assembles the drives.  naively and yet
happily i followed this advice, here:

http://lists.debian.org/debian-user/2011/06/msg02164.html

the problem was that uh, yeah, the ext4 filesystem _did_ end up
getting massively corrupted, very very quickly (within weeks), and i
don't entirely know how.  at approx 50% filled, i carried out another
copy operation of several tens of thousands of files (backup of a
system with about 10gb usage) and it was these files and directories
that had the worst level of filesystem corruption.

so my question is: has anyone else encountered significant filesystem
corruption of large (1000gb+) ext4 filesystems, with any *recent* 2.6
linux kernels?

tia,

l.

p.s. yes fsck has now been added to the drive assembly script, but i
am not yet filled with confidence that everything will be hunky-dory.
