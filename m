Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab0FZL7R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 07:59:17 -0400
Received: from mailgw02.dd24.net ([193.46.215.43]:36760 "EHLO
	mailgw02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab0FZL7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 07:59:15 -0400
Subject: (stupid) how to specify the root-device via kernel parameters
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Jun 2010 13:59:09 +0200
Message-ID: <1277553549.29791.38.camel@fermat.scientia.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,...

Ok this might sound really stupid, but I've seen several ways of doing
this and want to get this cleaned up.

Nevertheless....

kernel-parameters.txt has the following options where you can specify
the root-fs and related flags:
root=           [KNL] Root filesystem
nfsroot=        [NFS] nfs root filesystem for disk-less boxes.

Plus further options like: ro, rootdelay=, rootflags=, rootfstype=,
rootwait, etc.


My question:
These are intended (especially root/nfsroot) to really name the device,
on which the filesystem directly lays, right?
E.g. if the ext4-root-fs is on /dev/sda1,... => root=/dev/sda1

I've seen several initramfs scripts (which I'd like to fix),... where
people abuse this or misuse this in setups where a root-fs is used on
multi-stacked block layers (e.g. something like disk->lvm->dm-crypt->fs)


Cheers,
Chris.

