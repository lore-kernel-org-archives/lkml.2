Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150Ab2CMJRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:17:45 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43273 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758567Ab2CMJRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:17:44 -0400
MIME-Version: 1.0
Date: Tue, 13 Mar 2012 09:17:43 +0000
Message-ID: <CAH4Ag-AtVR5CU6fifa3+PRT=SJ+z9Tr898=BAV0EptEJ2mavbw@mail.gmail.com>
Subject: kernel 3.3 btrfs possible corrupt data
From: Simon Jones <sijones2010@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wanted to see if anyone else has had or spotted a potential issue
with regard to some corruption of data.

I have a tv pc running Arch, and my laptop running Arch, over the
weekend I noticed some issues with my tv system and went to recompile
myth, this failed and caused a lock of the system with a segfault of
the btrfs module (all partitions are btrfs except boot)

I rebooted thinking it was a one off and re-tried, I currently have
issues with usb and my dvb-t2 tuner, so tried again and it did the
same with locking up and the segfault, so seeing the btrfs issue bug I
ran 3.3 to see if that was the issue, this then caused me to see more
data corruption in the mysql database for myth, trying to repair it
caused a lock up.

I was also seeing btrfs errors of checksum not matching etc, so to try
and repair I took the SSD out and put it in my laptop, I couldn't seem
to repair it wit the new btrfsck and it seems that's it's failing with
an assert.c line 147 error.

Reading up about SSD and the things they do, I believe because it's
using a sandforce controller, the deduplication of blocks has caused
an error that can not be repaired due to the additional blocks not
being available.

On top of this when the ssd was in my laptop, I couldn't unmount the
SSD and shutdown so had to poweroff, this was fine, but when I used
kernel 3.3 my boot system got damaged and I had to do a repair using a
live boot, this corruption only happens when running on kernel 3.3 and
not shutting down cleanly.

I hope this helps with anyone else who thinks they may be having issues.

Regards,

Simon
