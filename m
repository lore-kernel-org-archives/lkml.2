Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab0CPWp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 18:45:28 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:33021 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab0CPWp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 18:45:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:references:in-reply-to:subject:date:message-id:mime-version
         :content-type:content-transfer-encoding:x-mailer:thread-index
         :content-language;
        b=OycguKes7eY4ymmMhcnSkQOvwe3xVuN05EKDhFW61Ikt4grxdzZp/9rGftOjoTb1aG
         VcyavEfSfZY+hYgNeT8uCNb/5kOnOy5wyOZ/ukxiLwud0JnBV67ygbHjY/qjUP8bovps
         s4ZoWVY1QKD+TFE9ckuOGmu6j/yXONql58tVM=
From: "Will L Givens" <wlgivens@gmail.com>
To: "'Will L Givens'" <wlgivens@gmail.com>, <linux-kernel@vger.kernel.org>
References: 
In-Reply-To: 
Subject: Loading aic7xxx.Unable to handle kernel paging request at virtual address (linux-2.6.33-rc1 and linux-2.6.33-git15)
Date: Tue, 16 Mar 2010 17:44:54 -0500
Message-ID: <007901cac55a$4e250d20$ea6f2760$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcrFVWjn8loJaM89ROKPJ+zz+GuXagAAitOQAACpeVA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel was built using the following toolchain
GCC-3.4.3 (GCC-4.4.2 generates too many header errors, GCC-4.0.1 is not
'new' enough)
Binutils-2.20.1
Make-3.80
GLIBC-2.4-11 (I believe this may be part of the problem. Currently in the
process of updating but running into too many header errors and 'make
install-headers' files to work properly, may do chroot build)

usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
oprofile: using alpha/ev67 performance monitoring.
TCP cubic registered
rtc-test rtc-test.0: setting system clock to 2010-03-16 17:26:39 UTC
(1268760399)
Freeing unused kernel memory: 208k freed
Red Hat nash version 5.0.32 starting
Mounting proc filesystem
Mounting sysfs filesystem
Creating /dev
Creating initial device nodes
Setting up hotplug.
Creating block device nodes.
Loading aic7xxx.Unable to handle kernel paging request at virtual address
036b036903670360
ko module
insmod(375): Oops -1
pc = [<036b036903670360>]  ra = [<fffffffc0089c9d8>]  ps = 0000    Not
tainted
v0 = 0000000000000001  t0 = 0000000000000001  t1 = 00000000000003ff
t2 = 0000000000000000  t3 = 0000000000000000  t4 = fffffc007d9c7a20
t5 = fffffffc008acc70  t6 = 000000000000000f  t7 = fffffc007d9c4000
s0 = fffffffc008acc90  s1 = 000000000000036b  s2 = 000000000000036b
s3 = fffffc007d9c79f8  s4 = fffffc007d9c7a28  s5 = fffffc007da1bc00
s6 = fffffffc008ad930
a0 = fffffc007da1bc00  a1 = fffffc007d9c7a28  a2 = 000000000000036b
a3 = fffffc007d9c79f8  a4 = fffffc007d9c7b48  a5 = fffffffc0089b434
t8 = fffffc00009001d0  t9 = 0000000000000002  t10= 0000000000000000
t11= 0000000000000001  pv = 036b036903670361  at = 00000000ffffffff
gp = fffffffc008ad7e0  sp = fffffc007d9c78c8
Disabling lock debugging due to kernel taint
Trace:
[<fffffc0000539cec>]
[<fffffc0000520504>]
[<fffffc000059f264>]
[<fffffc0000539fac>]
[<fffffc000053a0d4>]
[<fffffc00005a3a48>]
[<fffffc00005a3cd4>]
[<fffffc00005a2070>]
[<fffffc00005a3c4c>]
[<fffffc00005a3d4c>]
[<fffffc00005a2b9c>]
[<fffffc00005a4568>]
[<fffffc00005a452c>]
[<fffffc0000539d94>]
[<fffffc00003100cc>]
[<fffffc0000351454>]
[<fffffc0000310bb4>]

Code:
Loading dm-log.ko module
Loading dm-region-hash.ko module
Loading dm-mirror.ko module
Loading dm-snapshot.ko module
Making device-mapper control node
Scanning logical volumes
  Reading all physical volumes.  This may take a while...
  No volume groups found
Activating logical volumes
  Unable to find volume group "VolGroup00"
Creating root device.
Mounting root filesystem.
mount: could not find filesystem '/dev/root'
Setting up other filesystems.
Setting up new root fs
setuproot: moving /dev failed: No such file or directory
no fstab.sys, mounting internal defaults
setuproot: error mounting /proc: No such file or directory
setuproot: error mounting /sys: No such file or directory
Switching to new root and running init.
unmounting old /dev
unmounting old /proc
unmounting old /sys
switchroot: mount failed: No such file or directory
Kernel panic - not syncing: Attempted to kill init!


