Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab1IHC0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 22:26:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50424 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757865Ab1IHC03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 22:26:29 -0400
Message-ID: <4E682881.7040900@vlnb.net>
Date: Wed, 07 Sep 2011 22:29:21 -0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110424 Mnenhy/0.8.3 Thunderbird/3.1.10
MIME-Version: 1.0
To: scst-devel <scst-devel@lists.sourceforge.net>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        Bart Van Assche <bart.vanassche@gmail.com>,
        Mark Buechler <mark.buechler@gmail.com>
Subject: [ANNOUNCE]: Released version 2.1 of SCST core, target drivers iSCSI-SCST,
 qla2x00t (QLogic FC), ib_srpt (InfiniBand SRP) and scst_local with scstadmin
 utility and fileio_tgt user space backend handler
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:paU73uHEjCqdy1ICfeLrDWl574/Stp01IPwWkUQqNqS
 7CK600sHDc/acCz5fqlwoV8MG3ecW9sz40NA04SpUnv3IEouKX
 pHWjQP2h+5QGF/qTDJYsD9gyxvI5Dm5iDtRi3pWZtw+U2JYZgG
 2JUHUyoIvzbDXuhd6EbXiRrorA7JWiJKef0SZGxbvU9ShOlLf2
 y1xyqj30B7UeODGMRgZYDYZofLJ/LThh8+I4QIn4NjcLsiIJMC
 RcensHaxecUmu8PxvIbQtIFQU78F1VjucNW4fW/76KKXv+x10S
 FNbNLRSvp3UNhnWahGmSQvDKx2ghitX9xQBHqF8uQ+nckOkVV8
 crIpr7KThteuxH/1V9Xw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm glad to announce stable release 2.1 of SCST, the most advanced, features rich
and the highest performance SCSI target stack for Linux with target drivers for
iSCSI (iSCSI-SCST), QLogic Fibre Channel 22xx/23xx/24xx/25xx (qla2x00t),
InfiniBand SRP (ib_srpt), scst_local as well as user space scstadmin management
utility and fileio_tgt user space backend handler.

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

Thanks to all who made it happen, especially to Bart Van Assche for ib_srpt
development and a lot of other SCST activities and Mark Buechler for great
scstadmin tool!

Vlad

