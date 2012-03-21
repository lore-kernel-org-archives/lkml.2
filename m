Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab2CUE2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 00:28:21 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60720 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2CUE2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 00:28:17 -0400
MIME-Version: 1.0
Date: Wed, 21 Mar 2012 12:28:16 +0800
Message-ID: <CAN628AHEYG4PBrnKGE7tv13FNu08-oFCa+FAiDfaLUHjbq998w@mail.gmail.com>
Subject: [PATCH] VMUFAT filesystem [0/4]
From: Adrian McMenamin <lkmladrian@gmail.com>
To: viro@zeniv.linux.org.uk, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Cc: Linux-sh <linux-sh@vger.kernel.org>,
        Adrian McMenamin <adrianmcmenamin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sega Dreamcasts come with a "visual memory unit" (VMU) a
micro-controller based peripheral with a small LCD screen and 128K of
flash memory. The flash is partitioned as a file allocation table
(FAT) based volume.

The only physical VMUs released were limited to 128K of memory but it
was generally believed that Sega planned to introduce devices with
bigger memories and certainly the syntax of the filesystem, which I
call VMUFAT, allows for larger volumes.

Some years ago I contributed a driver for the VMU's flash and
attempted to contribute one for the filesystem (see
https://lkml.org/lkml/2009/2/14/127 for instance).

I am not sure how many people are still hacking away at Linux on their
Dreamcasts, but Linux or Android emulators exist for the Dreamcast and
the VMU, so supporting the filesystem has a potential use.

Adrian McMenamin
