Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167Ab0K0GVk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 01:21:40 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33249 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab0K0GVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 01:21:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=L6YutA6H882wfx7EZ964wZXxiNAFlalOLDEQRwMEz60LTMypzAkEtjvGuZqCjHG7wh
         oCXUfDyPcewa8vgAvdvOjzCw0nVAMI06IDSBA+5R6cIhWFK8vJ5oLm2GOGc7osyDY11G
         k+Kio10Lsubi17+R05q3lglQISx2TzuFAoE2M=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-rdma@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 0/9] Change the copyright info. 
Date: Fri, 26 Nov 2010 22:21:10 -0800
Message-Id: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org








Below you will find a set of patches, that update the copyright info from
Sun Microsystems to Oracle.

Please let me know if I missed anything and/or should make changes..


 drivers/ata/pata_hpt366.c                      |    2 +-
 drivers/ata/pata_hpt37x.c                      |    2 +-
 drivers/ata/pata_hpt3x2n.c                     |    2 +-
 drivers/ata/pata_serverworks.c                 |    2 +-
 drivers/char/nvram.c                           |    2 +-
 drivers/ide/hpt366.c                           |    2 +-
 drivers/ide/serverworks.c                      |    2 +-
 drivers/infiniband/core/agent.c                |    2 +-
 drivers/infiniband/core/cache.c                |    2 +-
 drivers/infiniband/core/cm.c                   |    2 +-
 drivers/infiniband/core/device.c               |    2 +-
 drivers/infiniband/core/fmr_pool.c             |    2 +-
 drivers/infiniband/core/iwcm.c                 |    2 +-
 drivers/infiniband/core/mad_priv.h             |    2 +-
 drivers/infiniband/core/packer.c               |    2 +-
 drivers/infiniband/core/smi.c                  |    2 +-
 drivers/infiniband/core/sysfs.c                |    2 +-
 drivers/infiniband/core/ud_header.c            |    2 +-
 drivers/infiniband/core/user_mad.c             |    2 +-
 drivers/infiniband/core/verbs.c                |    2 +-
 drivers/infiniband/hw/amso1100/c2_cq.c         |    2 +-
 drivers/infiniband/hw/mthca/mthca_av.c         |    2 +-
 drivers/infiniband/hw/mthca/mthca_cq.c         |    2 +-
 drivers/infiniband/hw/mthca/mthca_dev.h        |    2 +-
 drivers/infiniband/hw/mthca/mthca_doorbell.h   |    2 +-
 drivers/infiniband/hw/mthca/mthca_main.c       |    2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c   |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib.h           |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    2 +-
 drivers/mtd/maps/scb2_flash.c                  |    2 +-
 drivers/net/cassini.c                          |    2 +-
 drivers/net/cassini.h                          |    4 ++--
 drivers/net/mlx4/cq.c                          |    2 +-
 drivers/net/mlx4/main.c                        |    2 +-
 drivers/net/mlx4/mlx4.h                        |    2 +-
 drivers/net/natsemi.c                          |    2 +-
 drivers/net/tg3.c                              |    2 +-
 drivers/net/tg3.h                              |    2 +-
 include/linux/ethtool.h                        |    4 ++--
 include/linux/mlx4/doorbell.h                  |    2 +-
 include/rdma/ib_cache.h                        |    2 +-
 include/rdma/ib_cm.h                           |    2 +-
 include/rdma/ib_fmr_pool.h                     |    2 +-
 include/rdma/ib_verbs.h                        |    2 +-
 46 files changed, 48 insertions(+), 48 deletions(-)


Justin P. Mattock
