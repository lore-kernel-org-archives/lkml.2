Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab1EXLsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 07:48:52 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:58964 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751098Ab1EXLsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 07:48:51 -0400
Date: Tue, 24 May 2011 11:19:47 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: [git pull] PCMCIA updates for 2.6.40 or whatever
Message-ID: <20110524091946.GA28923@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

a few PCMCIA updates have accumulated in the PCMCIA tree, so please pull
from

git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git master

for the next release.

Thanks,
	Dominik

Joe Perches (4):
      pcmcia: Make declaration and uses of struct pcmcia_device_id const
      pcmcia: Convert pcmcia_device_id declarations to const
      staging: pcmcia: Convert pcmcia_device_id declarations to const
      pcmcia: Make struct pcmcia_device_id const, sound drivers edition

Uwe Kleine-König (1):
      pcmcia/sa1100: put sa11x0_pcmcia_hw_init[] to .devinit.data

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
 drivers/pcmcia/sa1100_generic.c                  |    2 +-
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
 sound/pcmcia/pdaudiocf/pdaudiocf.c               |    2 +-
 sound/pcmcia/vx/vxpocket.c                       |    2 +-
 60 files changed, 63 insertions(+), 63 deletions(-)
