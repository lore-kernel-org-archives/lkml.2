Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab2AZFw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 00:52:29 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62128 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2AZFw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 00:52:27 -0500
Message-ID: <4F20EA10.9070607@vlnb.net>
Date: Thu, 26 Jan 2012 00:52:16 -0500
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111108 Mnenhy/0.8.3 Thunderbird/3.1.16
MIME-Version: 1.0
To: scst-devel <scst-devel@lists.sourceforge.net>
CC: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [ANNOUNCE]: Released version 2.2 of SCST core, target drivers iSCSI-SCST,
 qla2x00t (QLogic FC), ib_srpt (InfiniBand SRP) and scst_local with scstadmin
 utility and fileio_tgt user space backend handler
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:4VGA81Nu96IJ4k5AUKjJqOV8CLcaxgNevfgVO1h8koV
 KDnthvtRZKSLbOhk+ICZPfjErsVuxNzxfMTHNWCrP/+zZizusD
 q6E/JYLnL2bN1uTtxMa5t8YVNqA3EpdkVv2IF6BE/QCDxWx57I
 Nf9oglbJhSp5D5Q4oRxD2mIBvz9ZkkKSlFai5Dma84SMU0GyYb
 IB6UG+rxmIl2eAW7vjgXbdu0eaRhBsCGxbYz5XpvfeyEYp0KJL
 Sv0T3KtO4CZPggNPVMmR60HDRqOIXNZ5ummWJ2JOgRn4MaGe8u
 wjmDtfSUzOiv3wOHJfVx/g07HxLMQSIhduxgozX0k3nqlPKtUI
 jDIdQoSDCLsWotYSHKUk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm glad to announce a stable release 2.2 of SCST, alternative SCSI target
stack for Linux with target drivers for iSCSI (iSCSI-SCST), QLogic Fibre Channel
22xx/23xx/24xx/25xx (qla2x00t), InfiniBand SRP (ib_srpt), scst_local as well as
user space scstadmin management utility and fileio_tgt user space backend handler.

SCST allows creation of sophisticated storage devices, which provide advanced
functionality, like replication, thin provisioning, deduplication, high
availability, automatic backup, etc. Another class of such devices are Virtual
Tape Libraries (VTL) as well as other disk-based backup solutions. SCST created
devices not limited by IP network interface only, but they can use any link
supporting SCSI-style data exchange, including Fibre Channel, SAS and parallel
SCSI. It might well be that your favorite storage appliance running SCST in the
firmware.

More info about SCST core and modules you can find on:

   - SCST core: http://scst.sourceforge.net

   - iSCSI target driver iSCSI-SCST: http://iscsi-scst.sourceforge.net/index.html

   - QLogic 22xx/23xx/24xx/25xx Fibre Channel target driver:
http://scst.sourceforge.net/target_qla2x00t.html

   - InfiniBand SRP: http://scst.sourceforge.net/target_srp.html

   - scst_local: http://scst.sourceforge.net/target_local.html

   - fileio_tgt backend handler:
http://scst.sourceforge.net/handler_fileio_tgt.html.

You can download SCST core and modules from
http://scst.sourceforge.net/downloads.html.

Thanks to all who made it happen!

Vlad

