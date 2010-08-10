Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab0HJIS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 04:18:28 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:38047 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab0HJISY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 04:18:24 -0400
Date: Tue, 10 Aug 2010 10:18:18 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.35+
Message-ID: <20100810101818.4e39541a@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Heiko Carstens (3):
      [S390] cmm: add missing __init/__exit annotations
      [S390] initrd: change default load address
      [S390] topology: use default MC domain initializer

Hendrik Brueckner (1):
      [S390] cmm, smsgiucv_app: convert sender to uppercase

Michael Ernst (2):
      [S390] cio: CHSC SIOSL Support
      [S390] cio: Log the response from the unit check handler

Sebastian Ott (3):
      [S390] cio: ccw_device_online_store return -EINVAL in case of missing driver
      [S390] ccwreq: add ability to use all paths
      [S390] cio: use all available paths for some internal I/O

Stefan Haberland (1):
      [S390] dasd: tunable missing interrupt handler

Stefan Weinhuber (1):
      [S390] dasd: allocate fallback cqr for reserve/release

 arch/s390/include/asm/ccwdev.h   |    2 +
 arch/s390/include/asm/topology.h |    2 -
 arch/s390/kernel/head.S          |    2 +-
 arch/s390/mm/cmm.c               |   11 ++++-
 drivers/s390/block/dasd_devmap.c |   44 ++++++++++++++++++
 drivers/s390/block/dasd_diag.c   |    6 ++-
 drivers/s390/block/dasd_eckd.c   |   94 +++++++++++++++++++++++++++++++-------
 drivers/s390/block/dasd_eckd.h   |    7 ++-
 drivers/s390/block/dasd_fba.c    |    4 +-
 drivers/s390/block/dasd_int.h    |    8 +++-
 drivers/s390/cio/ccwreq.c        |   16 +++++-
 drivers/s390/cio/chsc.c          |   48 +++++++++++++++++++
 drivers/s390/cio/chsc.h          |    2 +
 drivers/s390/cio/device.c        |   47 +++++++++++++++++--
 drivers/s390/cio/device_pgid.c   |    3 +
 drivers/s390/cio/io_sch.h        |   10 ++--
 drivers/s390/net/smsgiucv_app.c  |    7 +++
 17 files changed, 275 insertions(+), 38 deletions(-)

