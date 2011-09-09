Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab1IIIF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:05:26 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41985 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758461Ab1IIIFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:05:21 -0400
MIME-Version: 1.0
From: Harshada Sangale <sweets21777@gmail.com>
Date: Fri, 9 Sep 2011 13:35:00 +0530
Message-ID: <CABoV-Et_dC4KkDnw+TBxd-DV1gR8VS1VaYm45BOFYLVmCLkwSQ@mail.gmail.com>
Subject: Running in some issues to get LIO-Target Up
To: linux-kernel@vger.kernel.org
Cc: KQ-Prasad Joshi <prasadjoshi124@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to get LIO-target up for Rhel machine.Refered to the link below:
http://www.stephenwagner.com/?p=242

Compiled the kernel and installed the lio.
[root@ganesh-Studio-1558-relVM target]# modprobe target_core_mod

Inserted the module. But running in some issues


[root@ganesh-Studio-1558-relVM ~]# tcm_node
bash: /usr/sbin/tcm_node: Permission denied
[root@ganesh-Studio-1558-relVM ~]# lio_node
bash: /usr/sbin/lio_node: Permission denied


[root@ganesh-Studio-1558-relVM ~]# python /usr/sbin/tcm_node
Traceback (most recent call last):
  File "/usr/sbin/tcm_node", line 739, in <module>
    main()
  File "/usr/sbin/tcm_node", line 715, in main
    parser = OptionParser(version=tcm_version())
  File "/usr/sbin/tcm_node", line 603, in tcm_version
    return tcm_read("/sys/kernel/config/target/version").strip()
  File "/usr/sbin/tcm_node", line 26, in tcm_read
    with open(filename) as f:
IOError: [Errno 2] No such file or directory:
'/sys/kernel/config/target/version'

Can any one please let me know where am I going wrong?


-- 
Harshada Sangale
MCA@PUCSD
9689187388
