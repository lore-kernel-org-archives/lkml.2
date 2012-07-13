Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab2GMU6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 16:58:54 -0400
Received: from smtprelay0041.b.hostedemail.com ([64.98.42.41]:46812 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750970Ab2GMU6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 16:58:52 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jul 2012 16:58:52 EDT
X-Panda: scanned!
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 1465
Date: Fri, 13 Jul 2012 20:50:43 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: linux-kernel@vger.kernel.org
Message-ID: <2129604960.58317.1342212643807.JavaMail.mail@webmail10>
Subject: Kernel 3.5-rc5 cannot boot my PC - partitions parsing issues
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [37.112.121.152]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I took my Linux 3.3 configuration, made oldconfig on top of it, removed a few unneeded options
and now Linux kernel 3.5-rc6 doesn't boot:

VFS: Cannot open root device "sda2" or unknown-block(0,0): error -6
Please append a correct "root=" boot option; here are the available partitions:
<EMPTY LIST>
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)

I haven't changed anything in regard to the storage subsystem or block device support, I even
explicitly enabled:

CONFIG_PARTITION_ADVANCED=y
CONFIG_MSDOS_PARTITION=y

to no avail.

I've posted the relevant information here: https://bugzilla.kernel.org/show_bug.cgi?id=44771

Please advise.
