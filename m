Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab1CZBSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:18:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44918 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932115Ab1CZBSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:18:36 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19X3roUUXtX7tUx/6xzxapgC/AtSHDQyy5TTVOH82
	bzsYt1chcsap4z
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 04/27] staging/comedi: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:17:53 +0100
Message-Id: <1301102296-15565-5-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20110314224746.GA21100@kroah.com>
References: <20110314224746.GA21100@kroah.com>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some very common spelling mistakes in
drivers/staging/comedi.

WRONG -> RIGHT
interupt	-> interrupt
occured     -> occurred
recieve     -> receive
writting	-> writing

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/comedi/comedi_fops.c               |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2032.c      |    8 ++++----
 drivers/staging/comedi/drivers/adv_pci1710.c       |    2 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         |    2 +-
 drivers/staging/comedi/drivers/comedi_test.c       |    2 +-
 drivers/staging/comedi/drivers/me4000.c            |    4 ++--
 drivers/staging/comedi/drivers/ni_at_a2150.c       |    4 ++--
 drivers/staging/comedi/drivers/ni_labpc.c          |    6 +++---
 drivers/staging/comedi/drivers/s626.c              |   12 ++++++------
 drivers/staging/comedi/drivers/unioxx5.c           |    4 ++--
 10 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index a4ceb29..e7e72b8 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -2064,7 +2064,7 @@ void comedi_event(struct comedi_device *dev, struct comedi_subdevice *s)
 			     COMEDI_CB_OVERFLOW)) {
 		runflags_mask |= SRF_RUNNING;
 	}
-	/* remember if an error event has occured, so an error
+	/* remember if an error event has occurred, so an error
 	 * can be returned the next time the user does a read() */
 	if (s->async->events & (COMEDI_CB_ERROR | COMEDI_CB_OVERFLOW)) {
 		runflags_mask |= SRF_ERROR;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
index 9dd857d..f5b8521 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
@@ -488,9 +488,9 @@ int i_APCI2032_ReadWatchdog(struct comedi_device *dev, struct comedi_subdevice *
 +----------------------------------------------------------------------------+
 | Output Parameters :	--													 |
 +----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
+| Return Value      : TRUE  : No error occurred                              |
+|		            : FALSE : Error occurred. Return the error               |
+|			                                                                 |
 +----------------------------------------------------------------------------+
 */
 void v_APCI2032_Interrupt(int irq, void *d)
@@ -498,7 +498,7 @@ void v_APCI2032_Interrupt(int irq, void *d)
 	struct comedi_device *dev = d;
 	unsigned int ui_DO;
 
-	ui_DO = inl(devpriv->iobase + APCI2032_DIGITAL_OP_IRQ) & 0x1;	/* Check if VCC OR CC interrupt has occured. */
+	ui_DO = inl(devpriv->iobase + APCI2032_DIGITAL_OP_IRQ) & 0x1;	/* Check if VCC OR CC interrupt has occurred. */
 
 	if (ui_DO == 0) {
 		printk("\nInterrupt from unKnown source\n");
diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 466e69f..0fd0ac5 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -98,7 +98,7 @@ Configuration options:
 #define	Status_FE	0x0100	/* 1=FIFO is empty */
 #define Status_FH	0x0200	/* 1=FIFO is half full */
 #define Status_FF	0x0400	/* 1=FIFO is full, fatal error */
-#define Status_IRQ	0x0800	/* 1=IRQ occured */
+#define Status_IRQ	0x0800	/* 1=IRQ occurred */
 /* bits from control register (PCI171x_CONTROL) */
 #define Control_CNT0	0x0040	/* 1=CNT0 have external source,
 				 * 0=have internal 100kHz source */
diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 0941643..f1824eb 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -440,7 +440,7 @@ struct cb_pcidas_private {
 	unsigned int divisor1;
 	unsigned int divisor2;
 	volatile unsigned int count;	/*  number of analog input samples remaining */
-	volatile unsigned int adc_fifo_bits;	/*  bits to write to interupt/adcfifo register */
+	volatile unsigned int adc_fifo_bits;	/*  bits to write to interrupt/adcfifo register */
 	volatile unsigned int s5933_intcsr_bits;	/*  bits to write to amcc s5933 interrupt control/status register */
 	volatile unsigned int ao_control_bits;	/*  bits to write to ao control and status register */
 	short ai_buffer[AI_BUFFER_SIZE];
diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index b220b30..a804742 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -81,7 +81,7 @@ static const struct waveform_board waveform_boards[] = {
 /* Data unique to this driver */
 struct waveform_private {
 	struct timer_list timer;
-	struct timeval last;	/* time at which last timer interrupt occured */
+	struct timeval last;	/* time at which last timer interrupt occurred */
 	unsigned int uvolt_amplitude;	/* waveform amplitude in microvolts */
 	unsigned long usec_period;	/* waveform period in microseconds */
 	unsigned long usec_current;	/* current time (modulo waveform period) */
diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 75511ba..b692fea 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -1810,7 +1810,7 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 		       ai_context->irq_status_reg) &
 	    ME4000_IRQ_STATUS_BIT_AI_HF) {
 		ISR_PDEBUG
-		    ("me4000_ai_isr(): Fifo half full interrupt occured\n");
+		    ("me4000_ai_isr(): Fifo half full interrupt occurred\n");
 
 		/* Read status register to find out what happened */
 		tmp = me4000_inl(dev, ai_context->ctrl_reg);
@@ -1903,7 +1903,7 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 	if (me4000_inl(dev,
 		       ai_context->irq_status_reg) & ME4000_IRQ_STATUS_BIT_SC) {
 		ISR_PDEBUG
-		    ("me4000_ai_isr(): Sample counter interrupt occured\n");
+		    ("me4000_ai_isr(): Sample counter interrupt occurred\n");
 
 		s->async->events |= COMEDI_CB_BLOCK | COMEDI_CB_EOA;
 
diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index 4d0053e..5928a72 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -106,8 +106,8 @@ TRIG_WAKE_EOS
 #define   OVFL_BIT		0x8	/*  fifo overflow */
 #define   EDAQ_BIT		0x10	/*  end of aquisition interrupt */
 #define   DCAL_BIT		0x20	/*  offset calibration in progress */
-#define   INTR_BIT		0x40	/*  interrupt has occured */
-#define   DMA_TC_BIT		0x80	/*  dma terminal count interrupt has occured */
+#define   INTR_BIT		0x40	/*  interrupt has occurred */
+#define   DMA_TC_BIT		0x80	/*  dma terminal count interrupt has occurred */
 #define   ID_BITS(x)	(((x) >> 8) & 0x3)
 #define IRQ_DMA_CNTRL_REG		0x12	/*  write only */
 #define   DMA_CHAN_BITS(x)		((x) & 0x7)	/*  sets dma channel */
diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 241fe52..f27e6b8 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -183,11 +183,11 @@ NI manuals:
 #define   OVERRUN_BIT	0x2
 /* fifo overflow */
 #define   OVERFLOW_BIT	0x4
-/* timer interrupt has occured */
+/* timer interrupt has occurred */
 #define   TIMER_BIT	0x8
-/* dma terminal count has occured */
+/* dma terminal count has occurred */
 #define   DMATC_BIT	0x10
-/* external trigger has occured */
+/* external trigger has occurred */
 #define   EXT_TRIG_BIT	0x40
 /* 1200 boards only */
 #define STATUS2_REG	0x1d
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index d5ba3ab..0f9aa01 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -1048,7 +1048,7 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 	uint8_t group;
 	uint16_t irqbit;
 
-	DEBUG("s626_irq_handler: interrupt request recieved!!!\n");
+	DEBUG("s626_irq_handler: interrupt request received!!!\n");
 
 	if (dev->attached == 0)
 		return IRQ_NONE;
@@ -1165,7 +1165,7 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 							(16 * group)))
 					    == 1 && cmd->start_src == TRIG_EXT) {
 						DEBUG
-						    ("s626_irq_handler: Edge capture interrupt recieved from channel %d\n",
+						    ("s626_irq_handler: Edge capture interrupt received from channel %d\n",
 						     cmd->start_arg);
 
 						/*  Start executing the RPS program. */
@@ -1194,7 +1194,7 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 					    && cmd->scan_begin_src ==
 					    TRIG_EXT) {
 						DEBUG
-						    ("s626_irq_handler: Edge capture interrupt recieved from channel %d\n",
+						    ("s626_irq_handler: Edge capture interrupt received from channel %d\n",
 						     cmd->scan_begin_arg);
 
 						/*  Trigger ADC scan loop start by setting RPS Signal 0. */
@@ -1236,7 +1236,7 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 					    == 1
 					    && cmd->convert_src == TRIG_EXT) {
 						DEBUG
-						    ("s626_irq_handler: Edge capture interrupt recieved from channel %d\n",
+						    ("s626_irq_handler: Edge capture interrupt received from channel %d\n",
 						     cmd->convert_arg);
 
 						/*  Trigger ADC scan loop start by setting RPS Signal 0. */
@@ -1805,7 +1805,7 @@ static int s626_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		DEBUG("s626_ai_cmd: NULL command\n");
 		return -EINVAL;
 	} else {
-		DEBUG("s626_ai_cmd: command recieved!!!\n");
+		DEBUG("s626_ai_cmd: command received!!!\n");
 	}
 
 	if (dev->irq == 0) {
@@ -2570,7 +2570,7 @@ static uint32_t I2Chandshake(struct comedi_device *dev, uint32_t val)
 	while ((RR7146(P_I2CCTRL) & (I2C_BUSY | I2C_ERR)) == I2C_BUSY)
 		;
 
-	/*  Return non-zero if I2C error occured. */
+	/*  Return non-zero if I2C error occurred. */
 	return RR7146(P_I2CCTRL) & I2C_ERR;
 
 }
diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 598884e..a69e450 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -314,7 +314,7 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
 		outb(i + 1, subdev_iobase + 5);	/* sends channel number to card */
 		outb('H', subdev_iobase + 6);	/* requests EEPROM world */
 		while (!(inb(subdev_iobase + 0) & TxBE))
-			;	/* waits while writting will be allowed */
+			;	/* waits while writing will be allowed */
 		outb(0, subdev_iobase + 6);
 
 		/* waits while reading of two bytes will be allowed */
@@ -450,7 +450,7 @@ static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
 	/* sending for bytes to module(one byte per cycle iteration) */
 	for (i = 0; i < 4; i++) {
 		while (!((inb(usp->usp_iobase + 0)) & TxBE))
-			;	/* waits while writting will be allowed */
+			;	/* waits while writing will be allowed */
 		outb(usp->usp_extra_data[module][i], usp->usp_iobase + 6);
 	}
 
-- 
1.7.3.4

