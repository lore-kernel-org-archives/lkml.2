Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab1EDC3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 22:29:07 -0400
Received: from mail.perches.com ([173.55.12.10]:1220 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634Ab1EDC3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 22:29:04 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Linux PCMCIA team <linux-pcmcia@lists.infradead.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 0/3] pcmcia: Make struct pcmcia_device_id const
Date: Tue,  3 May 2011 19:28:59 -0700
Message-Id: <cover.1304475547.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduces data use.

Staging could be applied now, but additional harmless warnings do result.

Joe Perches (3):
  pcmcia: Make declaration and uses of struct pcmcia_device_id const
  pcmcia: Convert pcmcia_device_id declarations to const
  staging: pcmcia: Convert pcmcia_device_id declarations to const

 drivers/ata/pata_pcmcia.c                        |    2 +-
 drivers/bluetooth/bluecard_cs.c                  |    2 +-
 drivers/bluetooth/bt3c_cs.c                      |    2 +-
 drivers/bluetooth/btuart_cs.c                    |    2 +-
 drivers/bluetooth/dtl1_cs.c                      |    2 +-
 drivers/char/pcmcia/cm4000_cs.c                  |    2 +-
 drivers/char/pcmcia/cm4040_cs.c                  |    2 +-
 drivers/char/pcmcia/synclink_cs.c                |    2 +-
 drivers/ide/ide-cs.c                             |    2 +-
 drivers/isdn/hardware/avm/avm_cs.c               |    2 +-
 drivers/isdn/hisax/avma1_cs.c                    |    2 +-
 drivers/isdn/hisax/elsa_cs.c                     |    2 +-
 drivers/isdn/hisax/sedlbauer_cs.c                |    2 +-
 drivers/isdn/hisax/teles_cs.c                    |    2 +-
 drivers/mmc/host/sdricoh_cs.c                    |    2 +-
 drivers/mtd/maps/pcmciamtd.c                     |    2 +-
 drivers/net/can/softing/softing_cs.c             |    2 +-
 drivers/net/pcmcia/3c574_cs.c                    |    2 +-
 drivers/net/pcmcia/3c589_cs.c                    |    2 +-
 drivers/net/pcmcia/axnet_cs.c                    |    2 +-
 drivers/net/pcmcia/com20020_cs.c                 |    2 +-
 drivers/net/pcmcia/fmvj18x_cs.c                  |    2 +-
 drivers/net/pcmcia/ibmtr_cs.c                    |    2 +-
 drivers/net/pcmcia/nmclan_cs.c                   |    2 +-
 drivers/net/pcmcia/pcnet_cs.c                    |    2 +-
 drivers/net/pcmcia/smc91c92_cs.c                 |    2 +-
 drivers/net/pcmcia/xirc2ps_cs.c                  |    2 +-
 drivers/net/wireless/airo_cs.c                   |    2 +-
 drivers/net/wireless/atmel_cs.c                  |    4 ++--
 drivers/net/wireless/b43/pcmcia.c                |    2 +-
 drivers/net/wireless/hostap/hostap_cs.c          |    2 +-
 drivers/net/wireless/libertas/if_cs.c            |    2 +-
 drivers/net/wireless/orinoco/orinoco_cs.c        |    2 +-
 drivers/net/wireless/orinoco/spectrum_cs.c       |    2 +-
 drivers/net/wireless/ray_cs.c                    |    2 +-
 drivers/net/wireless/wl3501_cs.c                 |    2 +-
 drivers/parport/parport_cs.c                     |    2 +-
 drivers/pcmcia/ds.c                              |    6 +++---
 drivers/scsi/pcmcia/aha152x_stub.c               |    2 +-
 drivers/scsi/pcmcia/fdomain_stub.c               |    2 +-
 drivers/scsi/pcmcia/nsp_cs.c                     |    2 +-
 drivers/scsi/pcmcia/qlogic_stub.c                |    2 +-
 drivers/scsi/pcmcia/sym53c500_cs.c               |    2 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c     |    2 +-
 drivers/staging/comedi/drivers/das08_cs.c        |    2 +-
 drivers/staging/comedi/drivers/ni_daq_700.c      |    2 +-
 drivers/staging/comedi/drivers/ni_daq_dio24.c    |    2 +-
 drivers/staging/comedi/drivers/ni_labpc_cs.c     |    2 +-
 drivers/staging/comedi/drivers/ni_mio_cs.c       |    2 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c |    2 +-
 drivers/staging/wlags49_h2/wl_cs.c               |    2 +-
 drivers/telephony/ixj_pcmcia.c                   |    2 +-
 drivers/tty/ipwireless/main.c                    |    2 +-
 drivers/tty/serial/serial_cs.c                   |    2 +-
 drivers/usb/host/sl811_cs.c                      |    2 +-
 include/pcmcia/ds.h                              |    2 +-
 57 files changed, 60 insertions(+), 60 deletions(-)

-- 
1.7.5.rc3.dirty

