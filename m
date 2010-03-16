Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759926Ab0CPRJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:09:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:43776 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759845Ab0CPRJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:09:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:cc:references:in-reply-to:subject:date:message-id:mime-version
         :content-type:content-transfer-encoding:x-mailer:thread-index
         :content-language;
        b=ohYvk1vuA1N77iQKmTD88RUVZ5jR2TxH6msCgRkM+kmRnqdEbpUr/TLZXl/9oAUq46
         MK4SBr+tqfOvnoxPcX54hRcePSyveOqpY43JNYQr0T4QPKEGiQJLA5gRdfvs9TPmPgKS
         7YoIX7eEfwuGpzNdBsfvhfdr5waUmYz6tv7RQ=
From: "Will L Givens" <wlgivens@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-alpha@vger.kernel.org>
References: <b4198de61003151609je8a94ceyf6dd39acfd1a5876@mail.gmail.com> <001e01cac4cc$98072ce0$c81586a0$@com> <4B9F2E56.2060303@orcon.net.nz>
In-Reply-To: <4B9F2E56.2060303@orcon.net.nz>
Subject: RE: Will's kernel compilation error
Date: Tue, 16 Mar 2010 12:09:07 -0500
Message-ID: <004a01cac52b$64cc59e0$2e650da0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcrE127VFl8RQ8YsRPW7FIf14jK4OwAU2zUw
Content-Language: en-us
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed the offending IDE controller, now getting the error below. Looks
like I need to create a NEW initrd image. I'll have to admit, I've done it
before but it this  is the first time I've ever gotten and 'error' for 'not'
doing it. I do have everything rolled into the kernel to boot without a
initrd but in the past I've never had that to work, so I'll stick with it
for now. *thank God for ccache*

TCP cubic registered
rtc-test rtc-test.0: setting system clock to 2010-03-16 16:51:13 UTC
(1268758273)
Freeing unused kernel memory: 208k freed
Red Hat nash version 5.0.32 starting
Mounting proc filesystem
Mounting sysfs filesystem
Creating /dev
Creating initial device nodes
Setting up hotplug.
Creating block device nodes.
scsi_mod: version magic '2.6.17-1.2187_FC5.6axp mod_unload gcc-4.1' should
be '2.6.34-rc1 mod_unload '
Loading scsi_modsd_mod: version magic '2.6.17-1.2187_FC5.6axp mod_unload
gcc-4.1' should be '2.6.34-rc1 mod_unload '
.ko module
insmscsi_transport_spi: version magic '2.6.17-1.2187_FC5.6axp mod_unload
gcc-4.1' should be '2.6.34-rc1 mod_unload '
od: error insertaic7xxx: version magic '2.6.17-1.2187_FC5.6axp mod_unload
gcc-4.1' should be '2.6.34-rc1 mod_unload '
ing '/lib/scsi_mjbd: version magic '2.6.17-1.2187_FC5.6axp mod_unload
gcc-4.1' should be '2.6.34-rc1 mod_unload '
od.ko': -1 Invalext3: version magic '2.6.17-1.2187_FC5.6axp mod_unload
gcc-4.1' should be '2.6.34-rc1 mod_unload '
id module formatdm_mod: version magic '2.6.17-1.2187_FC5.6axp mod_unload
gcc-4.1' should be '2.6.34-rc1 mod_unload '

Loading sd_moddm_mirror: version magic '2.6.17-1.2187_FC5.6axp mod_unload
gcc-4.1' should be '2.6.34-rc1 mod_unload '
.ko module
insmdm_zero: version magic '2.6.17-1.2187_FC5.6axp mod_unload gcc-4.1'
should be '2.6.34-rc1 mod_unload '
od: error insertdm_snapshot: version magic '2.6.17-1.2187_FC5.6axp
mod_unload gcc-4.1' should be '2.6.34-rc1 mod_unload '
ing '/lib/sd_mod.ko': -1 Invalid module format
Loading scsi_transport_spi.ko module
insmod: error inserting '/lib/scsi_transport_spi.ko': -1 Invalid module
format
Loading aic7xxx.ko module
insmod: error inserting '/lib/aic7xxx.ko': -1 Invalid module format
Loading jbd.ko module
insmod: error inserting '/lib/jbd.ko': -1 Invalid module format
Loading ext3.ko module
insmod: error inserting '/lib/ext3.ko': -1 Invalid module format
Loading dm-mod.ko module
insmod: error inserting '/lib/dm-mod.ko': -1 Invalid module format
Loading dm-mirror.ko module
insmod: error inserting '/lib/dm-mirror.ko': -1 Invalid module format
Loading dm-zero.ko module
insmod: error inserting '/lib/dm-zero.ko': -1 Invalid module format
Loading dm-snapshot.ko module
insmod: error inserting '/lib/dm-snapshot.ko': -1 Invalid module format
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

