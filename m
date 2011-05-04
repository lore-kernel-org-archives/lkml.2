Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab1EDC3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 22:29:31 -0400
Received: from mail.perches.com ([173.55.12.10]:1233 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab1EDC3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 22:29:05 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Linux PCMCIA team <linux-pcmcia@lists.infradead.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 3/3] staging: pcmcia: Convert pcmcia_device_id declarations to const
Date: Tue,  3 May 2011 19:29:02 -0700
Message-Id: <33054e3c683853a02a6af920dec74f6306fd1b89.1304475548.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1304475547.git.joe@perches.com>
References: <cover.1304475547.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduces data, increases text.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c     |    2 +-
 drivers/staging/comedi/drivers/das08_cs.c        |    2 +-
 drivers/staging/comedi/drivers/ni_daq_700.c      |    2 +-
 drivers/staging/comedi/drivers/ni_daq_dio24.c    |    2 +-
 drivers/staging/comedi/drivers/ni_labpc_cs.c     |    2 +-
 drivers/staging/comedi/drivers/ni_mio_cs.c       |    2 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c |    2 +-
 drivers/staging/wlags49_h2/wl_cs.c               |    2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index bb93685..8a1b8a7 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -772,7 +772,7 @@ static int das16cs_pcmcia_resume(struct pcmcia_device *link)
 
 /*====================================================================*/
 
-static struct pcmcia_device_id das16cs_id_table[] = {
+static const struct pcmcia_device_id das16cs_id_table[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x01c5, 0x0039),
 	PCMCIA_DEVICE_MANF_CARD(0x01c5, 0x4009),
 	PCMCIA_DEVICE_NULL
diff --git a/drivers/staging/comedi/drivers/das08_cs.c b/drivers/staging/comedi/drivers/das08_cs.c
index 0b32a2d..6d91d30 100644
--- a/drivers/staging/comedi/drivers/das08_cs.c
+++ b/drivers/staging/comedi/drivers/das08_cs.c
@@ -219,7 +219,7 @@ static int das08_pcmcia_resume(struct pcmcia_device *link)
 
 /*====================================================================*/
 
-static struct pcmcia_device_id das08_cs_id_table[] = {
+static const struct pcmcia_device_id das08_cs_id_table[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x01c5, 0x4001),
 	PCMCIA_DEVICE_NULL
 };
diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 6b7372e..2672629 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -552,7 +552,7 @@ static int dio700_cs_resume(struct pcmcia_device *link)
 
 /*====================================================================*/
 
-static struct pcmcia_device_id dio700_cs_ids[] = {
+static const struct pcmcia_device_id dio700_cs_ids[] = {
 	/* N.B. These IDs should match those in dio700_boards */
 	PCMCIA_DEVICE_MANF_CARD(0x010b, 0x4743),	/* daqcard-700 */
 	PCMCIA_DEVICE_NULL
diff --git a/drivers/staging/comedi/drivers/ni_daq_dio24.c b/drivers/staging/comedi/drivers/ni_daq_dio24.c
index c9c2858..49b824c 100644
--- a/drivers/staging/comedi/drivers/ni_daq_dio24.c
+++ b/drivers/staging/comedi/drivers/ni_daq_dio24.c
@@ -304,7 +304,7 @@ static int dio24_cs_resume(struct pcmcia_device *link)
 
 /*====================================================================*/
 
-static struct pcmcia_device_id dio24_cs_ids[] = {
+static const struct pcmcia_device_id dio24_cs_ids[] = {
 	/* N.B. These IDs should match those in dio24_boards */
 	PCMCIA_DEVICE_MANF_CARD(0x010b, 0x475c),	/* daqcard-dio24 */
 	PCMCIA_DEVICE_NULL
diff --git a/drivers/staging/comedi/drivers/ni_labpc_cs.c b/drivers/staging/comedi/drivers/ni_labpc_cs.c
index 6facbc8..832a517 100644
--- a/drivers/staging/comedi/drivers/ni_labpc_cs.c
+++ b/drivers/staging/comedi/drivers/ni_labpc_cs.c
@@ -267,7 +267,7 @@ static int labpc_cs_resume(struct pcmcia_device *link)
 	return 0;
 }				/* labpc_cs_resume */
 
-static struct pcmcia_device_id labpc_cs_ids[] = {
+static const struct pcmcia_device_id labpc_cs_ids[] = {
 	/* N.B. These IDs should match those in labpc_cs_boards (ni_labpc.c) */
 	PCMCIA_DEVICE_MANF_CARD(0x010b, 0x0103),	/* daqcard-1200 */
 	PCMCIA_DEVICE_NULL
diff --git a/drivers/staging/comedi/drivers/ni_mio_cs.c b/drivers/staging/comedi/drivers/ni_mio_cs.c
index 4956327..53ec24bb 100644
--- a/drivers/staging/comedi/drivers/ni_mio_cs.c
+++ b/drivers/staging/comedi/drivers/ni_mio_cs.c
@@ -416,7 +416,7 @@ static int ni_getboardtype(struct comedi_device *dev,
 
 #ifdef MODULE
 
-static struct pcmcia_device_id ni_mio_cs_ids[] = {
+static const struct pcmcia_device_id ni_mio_cs_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x010b, 0x010d),	/* DAQCard-ai-16xe-50 */
 	PCMCIA_DEVICE_MANF_CARD(0x010b, 0x010c),	/* DAQCard-ai-16e-4 */
 	PCMCIA_DEVICE_MANF_CARD(0x010b, 0x02c4),	/* DAQCard-6062E */
diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
index 82942e5..e0bb734 100644
--- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
@@ -1087,7 +1087,7 @@ static int daqp_cs_resume(struct pcmcia_device *link)
 
 #ifdef MODULE
 
-static struct pcmcia_device_id daqp_cs_id_table[] = {
+static const struct pcmcia_device_id daqp_cs_id_table[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x0137, 0x0027),
 	PCMCIA_DEVICE_NULL
 };
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
index 10af477..68ea035 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
@@ -284,7 +284,7 @@ static int ft1000_resume(struct pcmcia_device *link)
 
 /*====================================================================*/
 
-static struct pcmcia_device_id ft1000_ids[] = {
+static const struct pcmcia_device_id ft1000_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x02cc, 0x0100),
 	PCMCIA_DEVICE_MANF_CARD(0x02cc, 0x1000),
 	PCMCIA_DEVICE_MANF_CARD(0x02cc, 0x1300),
diff --git a/drivers/staging/wlags49_h2/wl_cs.c b/drivers/staging/wlags49_h2/wl_cs.c
index 6555891..a3a727c 100644
--- a/drivers/staging/wlags49_h2/wl_cs.c
+++ b/drivers/staging/wlags49_h2/wl_cs.c
@@ -378,7 +378,7 @@ int wl_adapter_close(struct net_device *dev)
 } /* wl_adapter_close */
 /*============================================================================*/
 
-static struct pcmcia_device_id wl_adapter_ids[] = {
+static const struct pcmcia_device_id wl_adapter_ids[] = {
 #if !((HCF_TYPE) & HCF_TYPE_HII5)
 	PCMCIA_DEVICE_MANF_CARD(0x0156, 0x0003),
 	PCMCIA_DEVICE_PROD_ID12("Agere Systems", "Wireless PC Card Model 0110",
-- 
1.7.5.rc3.dirty

