Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab0DWHGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 03:06:20 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:41685 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab0DWHGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 03:06:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=TA78VfcBJKTKCt/kBvCGmF7hKxnx+4zAU16BAX1g/LcW8boy4nXVE5I9t03H+XQbEa
         S07SyWV2WrOmuRz2uQJkxIg2si2VAzAOoKcACVeQ/ZZjU50RoHPAnay/O8+UNs6JQGda
         rNGaUgbCS3Mex1dlzrA7dmy5iLIjMVHCobbCU=
From: Pedro Francisco <pedrogfrancisco@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: ath5k misbehaving affecting other kernel parts unrelated?
Date: Fri, 23 Apr 2010 08:06:13 +0100
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004230806.13628.pedrogfrancisco@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings!

Is it possible a faulty ath5k module to affect diverse parts of kernel causing 
different oopses to happen referencing things as different as cdrom_ioctl, 
find_vma, i915_gem_object_get_pages, get_vfs_caps_from_disk, 
warn_slowpath_common (ath5k_tasklet_rx), proc_lookup_de and 
_spin_lock(ext4_getattr) [soft lookup]?

The task in which such errors happen is capturing packets with kismet during 
the night. The errors aren't easy to create, sometimes they've already 
happened when I check the computer in the morning and sometimes they require 
stirring up the computer a bit such as starting X.

I memtested the machine during 7h and no error was detected.

I've been trying different kernels but main one is 2.6.32-21-generic, Ubuntu 
flavour, with linux-backports-modules-wireless-lucid-generic installed. I would 
use 2.6.34-rc5 vanilla if shutdown and suspend worked ;)

As such:
a) is it "normal"? I thought modules were somewhat isolated these days.
b) any advices for debugging? I've yet to have two oopses that are similar....

Thank you in Advance,
-- 
Pedro
