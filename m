Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab0LUSgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:36:24 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56685 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab0LUSgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:36:18 -0500
Message-ID: <4D10F3BA.9040004@vlnb.net>
Date: Tue, 21 Dec 2010 21:36:42 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: linux-rdma@vger.kernel.org, Richard Sharpe <realrichardsharpe@gmail.com>,
        Bart Van Assche <bart.vanassche@gmail.com>,
        Mark Buechler <mark.buechler@gmail.com>
Subject: [ANNOUNCE]: Released version 2.0.0 of SCST core, target drivers iSCSI-SCST,
 qla2x00t (QLogic FC), ib_srpt (InfiniBand SRP) and scst_local as well as
 scstadmin utility and fileio_tgt user space backend handler
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:WhoktnKeQYc8qZmc0pDRHM7vnYu086CvB2U6zW3PzYf
 LM4kHAzRx3TLdhOPsd5jM+mV5n1cmcXM6kVu02hr03MwofsIOh
 mKIPe9BkNDZjKtgwvryOh2zYsptjjSdOOClwlnmMmSiyr64sNJ
 gNKEyIThgZz0aEezDSVoBTlLT6KuoAlzwr7hwAPLQcE2XUulFc
 aaAY5VEGzzRAGx0ac007Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm glad to announce stable release 2.0.0 of SCST core, target drivers
for iSCSI (iSCSI-SCST), QLogic Fibre Channel 22xx/23xx/24xx/25xx
(qla2x00t), InfiniBand SRP (ib_srpt), scst_local as well as scstadmin
management utility and fileio_tgt user space backend handler.

SCST is an alternative implementation of SCSI target subsystem for
Linux. It provides unified, consistent interface between SCSI target
drivers and Linux kernel as well as between Linux kernel and storage
backend handlers, connecting target drivers with real or emulated
storage backend.

SCST allows creation of sophisticated storage devices, which provide
advanced functionality, like replication, thin provisioning,
deduplication, high availability, automatic backup, etc. Another class
of such devices are Virtual Tape Libraries (VTL) as well as other
disk-based backup solutions. SCST created devices not limited by IP
network interface only, but they can use any link supporting SCSI-style
data exchange, including Fibre Channel, SAS and parallel SCSI. It might
well be that your favorite storage appliance running SCST in the firmware.

Target driver scst_local allows access to devices that are exported via
SCST directly on the same Linux system that they are exported from. It
makes no assumptions in the code about the device types on the target,
so any device handlers that you load in SCST will be visible, including
tapes and so forth. Additionally, it allows creation of fully functional
target drivers in user space.

Scstadmin utility allows to configure SCST, including its target drivers
and backend handlers, from config file, store live SCST configuration in
config file as well as detect and apply changes in the config file on
live SCST system.

More info about SCST core and modules you can find on:

   - SCST core: http://scst.sourceforge.net

   - iSCSI target driver iSCSI-SCST:
http://iscsi-scst.sourceforge.net/index.html

   - QLogic 22xx/23xx/24xx/25xx Fibre Channel target driver:
http://scst.sourceforge.net/target_qla2x00t.html

   - InfiniBand SRP: http://scst.sourceforge.net/target_srp.html

   - scst_local: http://scst.sourceforge.net/target_local.html

   - fileio_tgt backend handler:
http://scst.sourceforge.net/handler_fileio_tgt.html.

You can download SCST core and modules from
http://scst.sourceforge.net/downloads.html.

Thanks to all who made it happen, especially to Bart Van Assche for
ib_srpt development and a lot of other SCST activities, Mark Buechler
for great scstadmin tool and Richard Sharpe for scst_local!

Vlad

