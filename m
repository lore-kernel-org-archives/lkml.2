Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766Ab1J2SGv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 14:06:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40705 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933029Ab1J2SGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 14:06:50 -0400
Message-ID: <4EAC40B5.5060709@earnshaw.org.uk>
Date: Sat, 29 Oct 2011 19:06:45 +0100
From: Matt Earnshaw <matt@earnshaw.org.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Intermittent hard locks on 3.0.7-1 without information
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] 3.0.7-1 appears to cause hard locks intermittently, without information

[2.] Full description:
The system occasionally (approx. once or twice an hour) completely locks 
up, without caps-lock lights or responding to SysRq. Sounds being played 
loop, graphics output freezes etc. No clues are left in dmesg, or in any 
of the logs in /var/log. Downgrading to 3.0.6-2 resolves the issue.

[4.1.] Kernel version (from /proc/version):
(3.0.7-1) Linux version 3.0-ARCH (tobias@T-POWA-LX) (gcc version 4.6.1 
20110819 (prerelease) (GCC) ) #1 SMP PREEMPT Wed Oct 19 10:27:51 CEST 2011

[4.2.] Kernel .config file:
http://pastebin.com/XTXmUX8m

[5.] Most recent kernel version which did not have the bug:
3.0.6-2

[8.1.] Software (add the output of the ver_linux script here)
http://pastebin.com/qw8a9RFH

[8.2.] Processor information (from /proc/cpuinfo):
http://pastebin.com/AN0Df77y

[8.3.] Module information (from /proc/modules):
http://pastebin.com/LMThRSmg

[8.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
ioports: http://pastebin.com/R1aX4H8H
iomem: http://pastebin.com/z8srsFbD

[8.5.] PCI information ('lspci -vvv' as root)
http://pastebin.com/GbniVsFm

[8.6.] SCSI information (from /proc/scsi/scsi)
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: HITACHI HTS72323 Rev: EC2Z
   Type:   Direct-Access                    ANSI  SCSI revision: 05

[X.] Other notes, patches, fixes, workarounds:
Refer to https://bugs.archlinux.org/task/26614 for others with what is 
possibly the same problem.
