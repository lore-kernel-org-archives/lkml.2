Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468Ab0CaX6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 19:58:03 -0400
Received: from web94915.mail.in2.yahoo.com ([203.104.17.192]:21756 "HELO
	web94915.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755173Ab0CaX56 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 19:57:58 -0400
Message-ID: <836055.3581.qm@web94915.mail.in2.yahoo.com>
X-YMail-OSG: Qn1RPykVM1mU5OHcf.LrFs5r6j25tXfJhlL7klQpIa3l990
 Ho1IaeHs4VNFr3W8tnkRFx00PX2VJK16x_KPPW6roSiCPedJO975pztCbqqF
 itFwyOTpVps_s.ZR6h3kJW68JSN0auWtLI2jzK__1P.Jhgz2MKAlQSwxaLr5
 vzP1kaGhL0zdzfV9vPYJeIoTQzHBXrM.bTJCnPrPz8CRdHFyaemWpvPVAdz4
 AmCOkNCAG4tGBQYbPDxbVn2D4bu6yBoIqeE2UunAdazhn97Zmkwjz7CBjrZG
 mzuSLhGKMRUc8ZaiMuKC05T4-
X-RocketYMMF: pavan_savoy
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Thu, 1 Apr 2010 05:27:54 +0530 (IST)
From: Pavan Savoy <pavan_savoy@ti.com>
Reply-To: pavan_savoy@ti.com
Subject: Re: [PATCH] drivers:staging: sources for ST core
To: Greg KH <gregkh@suse.de>
Cc: Marcel Holtmann <marcel@holtmann.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100331202442.GC12995@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Thu, 1/4/10, Greg KH <gregkh@suse.de> wrote:

> From: Greg KH <gregkh@suse.de>
> Subject: Re: [PATCH] drivers:staging: sources for ST core
> To: "Pavan Savoy" <pavan_savoy@ti.com>
> Cc: "Marcel Holtmann" <marcel@holtmann.org>, alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
> Date: Thursday, 1 April, 2010, 1:54 AM
> On Thu, Apr 01, 2010 at 12:57:06AM
> +0530, Pavan Savoy wrote:
> > --- On Wed, 31/3/10, Greg KH <gregkh@suse.de>
> wrote:
> > 
> > > From: Greg KH <gregkh@suse.de>
> > > Subject: Re: [PATCH] drivers:staging: sources for
> ST core
> > > To: "Pavan Savoy" <pavan_savoy@ti.com>
> > > Cc: "Marcel Holtmann" <marcel@holtmann.org>,
> alan@lxorguk.ukuu.org.uk,
> linux-kernel@vger.kernel.org
> > > Date: Wednesday, 31 March, 2010, 11:49 PM
> > > On Wed, Mar 31, 2010 at 11:32:39PM
> > > +0530, Pavan Savoy wrote:
> > > > --- On Wed, 31/3/10, Greg KH <gregkh@suse.de>
> > > wrote:
> > > > 
> > > > > From: Greg KH <gregkh@suse.de>
> > > > > Subject: Re: [PATCH] drivers:staging:
> sources for
> > > ST core
> > > > > To: "Pavan Savoy" <pavan_savoy@ti.com>
> > > > > Cc: "Marcel Holtmann" <marcel@holtmann.org>,
> > > alan@lxorguk.ukuu.org.uk,
> > > linux-kernel@vger.kernel.org
> > > > > Date: Wednesday, 31 March, 2010, 11:00
> PM
> > > > > On Wed, Mar 31, 2010 at 04:20:22AM
> > > > > +0530, Pavan Savoy wrote:
> > > > > > 
> > > > > > --- On Wed, 31/3/10, Pavan Savoy
> <pavan_savoy@ti.com>
> > > > > wrote:
> > > > > > 
> > > > > > > From: Pavan Savoy <pavan_savoy@ti.com>
> > > > > > > Subject: Re: [PATCH]
> drivers:staging:
> > > sources for
> > > > > ST core
> > > > > > > To: gregkh@suse.de
> > > > > > > Cc: "Marcel Holtmann" <marcel@holtmann.org>,
> > > > > alan@lxorguk.ukuu.org.uk
> > > > > > > Date: Wednesday, 31 March,
> 2010, 4:11
> > > AM
> > > > > > > --- On Wed, 31/3/10, Pavan
> Savoy
> > > > > > > <pavan_savoy@yahoo.co.in>
> > > > > > > wrote:
> > > > > > > 
> > > > > > > > From: Pavan Savoy <pavan_savoy@yahoo.co.in>
> > > > > > > > Subject: Re: [PATCH]
> > > drivers:staging:
> > > > > sources for ST
> > > > > > > core
> > > > > > > > To: "pavan_savoy@yahoo.co.in"
> > > > > > > <pavan_savoy@yahoo.co.in>
> > > > > > > > Date: Wednesday, 31
> March, 2010,
> > > 4:06 AM
> > > > > > > > > From: Greg KH [gregkh@suse.de]
> > > > > > > > > Sent: Wednesday,
> March 31,
> > > 2010 3:17
> > > > > AM
> > > > > > > > > To: Savoy, Pavan
> > > > > > > > > Cc: Alan Cox; marcel@holtmann.org;
> > > > > > > > > linux-kernel@vger.kernel.org
> > > > > > > > > Subject: Re:
> [PATCH]
> > > drivers:staging:
> > > > > sources for
> > > > > > > ST
> > > > > > > > core
> > > > > > > > > 
> > > > > > > > > On Wed, Mar 31,
> 2010 at
> > > 02:35:55AM
> > > > > +0530, Pavan
> > > > > > > Savoy
> > > > > > > > > wrote:
> > > > > > > > > > So, something
> like the
> > > below is
> > > > > ok, I have
> > > > > > > > defined my
> > > > > > > > > own pr_fmt,
> > > > > > > > > > however
> default log
> > > level on my
> > > > > board is 7,
> > > > > > > and
> > > > > > > > hence
> > > > > > > > > pr_info is a bit
> > > > > > > > > > more annoying
> than
> > > usual.
> > > > > > > > > 
> > > > > > > > > No, a driver should
> use
> > > dev_dbg() and
> > > > > other
> > > > > > > > dev_printk()
> > > > > > > > > calls, not
> > > > > > > > > pr_debug() or
> anything like
> > > that.
> > > > > > > > > 
> > > > > > > > > Please don't roll
> your own
> > > formats, use
> > > > > the ones
> > > > > > > that
> > > > > > > > are
> > > > > > > > > well defined
> > > > > > > > > and uniquely
> describe your
> > > driver and
> > > > > device in
> > > > > > > a
> > > > > > > > format
> > > > > > > > > that the whole
> > > > > > > > > kernel uses.
> > > > > > > > 
> > > > > > > 
> > > > > > 
> > > > > > forgot lkml the last time..
> > > > > > 
> > > > > > Nope, I couldn't find any instance
> of struct
> > > device at
> > > > > all,
> > > > > > I need that to use dev_dbg right ?
> - None of
> > > the
> > > > > tty_*
> > > > > > structure accessible by ldiscs
> seems to have
> > > a
> > > > > reference to
> > > > > > it.
> > > > > > Also I happened to look at other
> line
> > > discipline
> > > > > driver, if
> > > > > > they have a smarter way of doing
> this, Nope
> > > - n_tty,
> > > > > n_hdlc,
> > > > > > n_slip all seem to use plain old
> printks.
> > > > > >? 
> > > > > > Any clues ??
> > > > > 
> > > > > Sorry, you are correct, we only have a
> struct
> > > kref right
> > > > > now for tty
> > > > > core objects, not a struct device.? So
> nevermind,
> > > this
> > > > > should be fine.
> > > > 
> > > > Oh cool. Thanks, So that leaves me with 1
> pending item
> > > from Alan which is to tie these 3 modules
> (KIM/Core/LL) up
> > > onto a TTY device specific context, and avoid all
> global
> > > ptrs.
> > > > 
> > > > So without that is it good to go in ?
> > > 
> > > Yes, care to do that and resubmit?
> > 
> > Oh, But that would take some major re-structuring with
> the driver, because with the existing driver being a
> platform_device/driver structure-I can't do that.
> > 
> > I have made it similar to TTY<->LDISCs, LDISCs
> register to TTY core, here BT/FM/GPS register to ST core.
> > TTY has a array of ldisc registered which is global,
> locked resource, I have st_gdata which is global and locked
> resource.
> > 
> > Each ldisc is to be in context of tty, because
> multiple UART exist, but this is also a platform device and
> exports symbols for other drivers to register in, so
> essentially only 1 such device exist per platform.
> > 
> > I agree it's unlike other device drivers in kernel,
> But is this unacceptable this way ?
> 
> Think about what you just said, I think you answered your
> own question
> :)
> 
> Please work on the change as requested.
> 
> thanks,

Ok, fixed up the ST core as suggested, no issues - works as is.
However, I just could not manage the kim_gdata not being global in st_kim.

All I want is an instance of structure I initialize in module_init, during _probe from platform_device.

Find below the patch where I cannot seem to manage without the kim_gdata global variable... - Any clues ?

>From 67cd43a2b3e9eee7fcdbe5185f8ef9b010ae8bdc Mon Sep 17 00:00:00 2001
From: Pavan Savoy <pavan_savoy@ti.com>
Date: Mon, 22 Mar 2010 13:19:39 -0400
Subject: [PATCH] drivers:staging: sources for Init manager module

Kernel Space Init-Manager works along with User-Mode
Init Manager daemon running to maintain the UART state.

Communication between user-space daemon and this module can be
	1. Via the pid written onto sysfs entry
	2. Via the rfkill subsystem

It also is a platform driver with a relevant platform device
in the board-*.c along with the list of BT/FM/GPS chip enable
gpio configuration

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/st_kim.c |  754 ++++++++++++++++++++++++++++++++++++++++
 drivers/staging/ti-st/st_kim.h |  150 ++++++++
 2 files changed, 904 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/ti-st/st_kim.c
 create mode 100644 drivers/staging/ti-st/st_kim.h

diff --git a/drivers/staging/ti-st/st_kim.c b/drivers/staging/ti-st/st_kim.c
new file mode 100644
index 0000000..98cbabb
--- /dev/null
+++ b/drivers/staging/ti-st/st_kim.c
@@ -0,0 +1,754 @@
+/*
+ *  Shared Transport Line discipline driver Core
+ *	Init Manager module responsible for GPIO control
+ *	and firmware download
+ *  Copyright (C) 2009 Texas Instruments
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#define pr_fmt(fmt) "(stk) :" fmt
+#include <linux/platform_device.h>
+#include <linux/jiffies.h>
+#include <linux/firmware.h>
+#include <linux/delay.h>
+#include <linux/wait.h>
+#include <linux/gpio.h>
+
+#include <linux/sched.h>
+
+#include "st_kim.h"
+/* understand BT events for fw response */
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci_core.h>
+#include <net/bluetooth/hci.h>
+
+
+static int kim_probe(struct platform_device *pdev);
+static int kim_remove(struct platform_device *pdev);
+
+/* KIM platform device driver structure */
+static struct platform_driver kim_platform_driver = {
+	.probe = kim_probe,
+	.remove = kim_remove,
+	/* TODO: ST driver power management during suspend/resume ?
+	 */
+#if 0
+	.suspend = kim_suspend,
+	.resume = kim_resume,
+#endif
+	.driver = {
+		   .name = "kim",
+		   .owner = THIS_MODULE,
+		   },
+};
+
+#ifndef LEGACY_RFKILL_SUPPORT
+static ssize_t show_pid(struct device *dev, struct device_attribute
+			*attr, char *buf);
+static ssize_t store_pid(struct device *dev, struct device_attribute
+			 *devattr, char *buf, size_t count);
+static ssize_t show_list(struct device *dev, struct device_attribute
+			 *attr, char *buf);
+
+/* structures specific for sysfs entries */
+static struct kobj_attribute pid_attr =
+__ATTR(pid, 0644, (void *)show_pid, (void *)store_pid);
+
+static struct kobj_attribute list_protocols =
+__ATTR(protocols, 0444, (void *)show_list, NULL);
+
+static struct attribute *uim_attrs[] = {
+	&pid_attr.attr,
+	/* add more debug sysfs entries */
+	&list_protocols.attr,
+	NULL,
+};
+
+static struct attribute_group uim_attr_grp = {
+	.attrs = uim_attrs,
+};
+#else
+static int kim_toggle_radio(void*, bool);
+static const struct rfkill_ops kim_rfkill_ops = {
+	.set_block = kim_toggle_radio,
+};
+#endif	/* LEGACY_RFKILL_SUPPORT */
+
+/* strings to be used for rfkill entries and by
+ * ST Core to be used for sysfs debug entry
+ */
+#define PROTO_ENTRY(type, name)	name
+const unsigned char *protocol_names[] = {
+	PROTO_ENTRY(ST_BT, "Bluetooth"),
+	PROTO_ENTRY(ST_FM, "FM"),
+	PROTO_ENTRY(ST_GPS, "GPS"),
+};
+
+struct kim_data_s	*kim_gdata;
+
+/**********************************************************************/
+/* internal functions */
+
+/*
+ * function to return whether the firmware response was proper
+ * in case of error don't complete so that waiting for proper
+ * response times out
+ */
+void validate_firmware_response(struct sk_buff *skb)
+{
+	if (unlikely(skb->data[5] != 0)) {
+		pr_err("no proper response during fw download");
+		pr_err("data6 %x", skb->data[5]);
+		return;		/* keep waiting for the proper response */
+	}
+	/* becos of all the script being downloaded */
+	complete_all(&kim_gdata->kim_rcvd);
+	kfree_skb(skb);
+}
+
+/* check for data len received inside kim_int_recv
+ * most often hit the last case to update state to waiting for data
+ */
+static inline int kim_check_data_len(int len)
+{
+	register int room = skb_tailroom(kim_gdata->rx_skb);
+
+	pr_info("len %d room %d", len, room);
+
+	if (!len) {
+		validate_firmware_response(kim_gdata->rx_skb);
+	} else if (len > room) {
+		/* Received packet's payload length is larger.
+		 * We can't accommodate it in created skb.
+		 */
+		pr_err("Data length is too large len %d room %d", len,
+			   room);
+		kfree_skb(kim_gdata->rx_skb);
+	} else {
+		/* Packet header has non-zero payload length and
+		 * we have enough space in created skb. Lets read
+		 * payload data */
+		kim_gdata->rx_state = ST_BT_W4_DATA;
+		kim_gdata->rx_count = len;
+		return len;
+	}
+
+	/* Change ST LL state to continue to process next
+	 * packet */
+	kim_gdata->rx_state = ST_W4_PACKET_TYPE;
+	kim_gdata->rx_skb = NULL;
+	kim_gdata->rx_count = 0;
+
+	return 0;
+}
+
+/* receive function called during firmware download
+ * - firmware download responses on different UART drivers
+ *   have been observed to come in bursts of different
+ *   tty_receive and hence the logic
+ */
+void kim_int_recv(const unsigned char *data, long count)
+{
+	register char *ptr;
+	struct hci_event_hdr *eh;
+	register int len = 0, type = 0;
+
+	pr_info("%s", __func__);
+	/* Decode received bytes here */
+	ptr = (char *)data;
+	if (unlikely(ptr == NULL)) {
+		pr_err(" received null from TTY ");
+		return;
+	}
+	while (count) {
+		if (kim_gdata->rx_count) {
+			len = min_t(unsigned int, kim_gdata->rx_count, count);
+			memcpy(skb_put(kim_gdata->rx_skb, len), ptr, len);
+			kim_gdata->rx_count -= len;
+			count -= len;
+			ptr += len;
+
+			if (kim_gdata->rx_count)
+				continue;
+
+			/* Check ST RX state machine , where are we? */
+			switch (kim_gdata->rx_state) {
+				/* Waiting for complete packet ? */
+			case ST_BT_W4_DATA:
+				pr_info("Complete pkt received");
+				validate_firmware_response(kim_gdata->rx_skb);
+				kim_gdata->rx_state = ST_W4_PACKET_TYPE;
+				kim_gdata->rx_skb = NULL;
+				continue;
+				/* Waiting for Bluetooth event header ? */
+			case ST_BT_W4_EVENT_HDR:
+				eh = (struct hci_event_hdr *)kim_gdata->
+				    rx_skb->data;
+				pr_info("Event header: evt 0x%2.2x"
+					   "plen %d", eh->evt, eh->plen);
+				kim_check_data_len(eh->plen);
+				continue;
+			}	/* end of switch */
+		}		/* end of if rx_state */
+		switch (*ptr) {
+			/* Bluetooth event packet? */
+		case HCI_EVENT_PKT:
+			pr_info("Event packet");
+			kim_gdata->rx_state = ST_BT_W4_EVENT_HDR;
+			kim_gdata->rx_count = HCI_EVENT_HDR_SIZE;
+			type = HCI_EVENT_PKT;
+			break;
+		default:
+			pr_info("unknown packet");
+			ptr++;
+			count--;
+			continue;
+		}		/* end of switch *ptr */
+		ptr++;
+		count--;
+		kim_gdata->rx_skb =
+		    bt_skb_alloc(HCI_MAX_FRAME_SIZE, GFP_ATOMIC);
+		if (!kim_gdata->rx_skb) {
+			pr_err("can't allocate mem for new packet");
+			kim_gdata->rx_state = ST_W4_PACKET_TYPE;
+			kim_gdata->rx_count = 0;
+			return;
+		} /* not necessary in this case */
+		bt_cb(kim_gdata->rx_skb)->pkt_type = type;
+	}			/* end of while count */
+	pr_info("done %s", __func__);
+	return;
+}
+
+static long read_local_version(char *bts_scr_name)
+{
+	unsigned short version = 0, chip = 0, min_ver = 0, maj_ver = 0;
+	char read_ver_cmd[] = { 0x01, 0x01, 0x10, 0x00 };
+
+	pr_info("%s", __func__);
+
+	INIT_COMPLETION(kim_gdata->kim_rcvd);
+	if (4 != st_int_write(kim_gdata->core_data, read_ver_cmd, 4)) {
+		pr_err("kim: couldn't write 4 bytes");
+		return ST_ERR_FAILURE;
+	}
+
+	if (!wait_for_completion_timeout
+	    (&kim_gdata->kim_rcvd, msecs_to_jiffies(CMD_RESP_TIME))) {
+		pr_err(" waiting for ver info- timed out ");
+		return ST_ERR_FAILURE;
+	}
+
+	version =
+	    MAKEWORD(kim_gdata->resp_buffer[13], kim_gdata->resp_buffer[14]);
+	chip = (version & 0x7C00) >> 10;
+	min_ver = (version & 0x007F);
+	maj_ver = (version & 0x0380) >> 7;
+
+	if (version & 0x8000)
+		maj_ver |= 0x0008;
+
+	sprintf(bts_scr_name, "TIInit_%d.%d.%d.bts", chip, maj_ver, min_ver);
+	pr_info("%s", bts_scr_name);
+	return ST_SUCCESS;
+}
+
+/* internal function which parses through the .bts firmware script file
+ * intreprets SEND, DELAY actions only as of now
+ */
+static long download_firmware(void)
+{
+	long err = ST_SUCCESS;
+	long len = 0;
+	register unsigned char *ptr = NULL;
+	register unsigned char *action_ptr = NULL;
+	unsigned char bts_scr_name[30] = { 0 };	/* 30 char long bts scr name? */
+
+	pr_info("%s", __func__);
+
+	err = read_local_version(bts_scr_name);
+	if (err != ST_SUCCESS) {
+		pr_err("kim: failed to read local ver");
+		return err;
+	}
+	err =
+	    request_firmware(&kim_gdata->fw_entry, bts_scr_name,
+			     &kim_gdata->kim_pdev->dev);
+	if (unlikely((err != 0) || (kim_gdata->fw_entry->data == NULL) ||
+		     (kim_gdata->fw_entry->size == 0))) {
+		pr_err(" request_firmware failed(errno %ld) for %s", err,
+			   bts_scr_name);
+		return ST_ERR_FAILURE;
+	}
+	ptr = (void *)kim_gdata->fw_entry->data;
+	len = kim_gdata->fw_entry->size;
+	/* bts_header to remove out magic number and
+	 * version
+	 */
+	ptr += sizeof(struct bts_header);
+	len -= sizeof(struct bts_header);
+
+	while (len > 0 && ptr) {
+		pr_info(" action size %d, type %d ",
+			   ((struct bts_action *)ptr)->size,
+			   ((struct bts_action *)ptr)->type);
+
+		switch (((struct bts_action *)ptr)->type) {
+		case ACTION_SEND_COMMAND:	/* action send */
+			action_ptr = &(((struct bts_action *)ptr)->data[0]);
+			if (unlikely
+			    (((struct hci_command *)action_ptr)->opcode ==
+			     0xFF36)) {
+				/* ignore remote change
+				 * baud rate HCI VS command */
+				pr_err
+				    (" change remote baud\
+				    rate command in firmware");
+				break;
+			}
+
+			INIT_COMPLETION(kim_gdata->kim_rcvd);
+			err = st_int_write(kim_gdata->core_data,
+			((struct bts_action_send *)action_ptr)->data,
+					   ((struct bts_action *)ptr)->size);
+			if (unlikely(err < 0)) {
+				release_firmware(kim_gdata->fw_entry);
+				return ST_ERR_FAILURE;
+			}
+			if (!wait_for_completion_timeout
+			    (&kim_gdata->kim_rcvd,
+			     msecs_to_jiffies(CMD_RESP_TIME))) {
+				pr_err
+				    (" response timeout during fw download ");
+				/* timed out */
+				release_firmware(kim_gdata->fw_entry);
+				return ST_ERR_FAILURE;
+			}
+			break;
+		case ACTION_DELAY:	/* sleep */
+			pr_info("sleep command in scr");
+			action_ptr = &(((struct bts_action *)ptr)->data[0]);
+			mdelay(((struct bts_action_delay *)action_ptr)->msec);
+			break;
+		}
+		len =
+		    len - (sizeof(struct bts_action) +
+			   ((struct bts_action *)ptr)->size);
+		ptr =
+		    ptr + sizeof(struct bts_action) +
+		    ((struct bts_action *)ptr)->size;
+	}
+	/* fw download complete */
+	release_firmware(kim_gdata->fw_entry);
+	return ST_SUCCESS;
+}
+
+/**********************************************************************/
+/* functions called from ST core */
+
+/* function to toggle the GPIO
+ * needs to know whether the GPIO is active high or active low
+ */
+void st_kim_chip_toggle(enum proto_type type, enum kim_gpio_state state)
+{
+	pr_info(" %s ", __func__);
+
+	if (kim_gdata->gpios[type] == -1) {
+		pr_info(" gpio not requested for protocol %s",
+			   protocol_names[type]);
+		return;
+	}
+	switch (type) {
+	case ST_BT:
+		/*Do Nothing */
+		break;
+
+	case ST_FM:
+		if (state == KIM_GPIO_ACTIVE)
+			gpio_set_value(kim_gdata->gpios[ST_FM], GPIO_LOW);
+		else
+			gpio_set_value(kim_gdata->gpios[ST_FM], GPIO_HIGH);
+		break;
+
+	case ST_GPS:
+		if (state == KIM_GPIO_ACTIVE)
+			gpio_set_value(kim_gdata->gpios[ST_GPS], GPIO_HIGH);
+		else
+			gpio_set_value(kim_gdata->gpios[ST_GPS], GPIO_LOW);
+		break;
+
+	case ST_MAX:
+	default:
+		break;
+	}
+
+	return;
+}
+
+/* called from ST Core, when REG_IN_PROGRESS (registration in progress)
+ * can be because of
+ * 1. response to read local version
+ * 2. during send/recv's of firmware download
+ */
+void st_kim_recv(void *disc_data, const unsigned char *data, long count)
+{
+	pr_info(" %s ", __func__);
+	/* copy to local buffer */
+	if (unlikely(data[4] == 0x01 && data[5] == 0x10 && data[0] == 0x04)) {
+		/* must be the read_ver_cmd */
+		memcpy(kim_gdata->resp_buffer, data, count);
+		complete_all(&kim_gdata->kim_rcvd);
+		return;
+	} else {
+		kim_int_recv(data, count);
+		/* either completes or times out */
+	}
+	return;
+}
+
+/* to signal completion of line discipline installation
+ * called from ST Core, upon tty_open
+ */
+void st_kim_complete(void)
+{
+	complete(&kim_gdata->ldisc_installed);
+}
+
+/* called from ST Core upon 1st registration
+*/
+long st_kim_start(void)
+{
+	long err = ST_SUCCESS;
+	long retry = POR_RETRY_COUNT;
+	pr_info(" %s", __func__);
+
+	do {
+#ifdef LEGACY_RFKILL_SUPPORT
+		/* TODO: this is only because rfkill sub-system
+		 * doesn't send events to user-space if the state
+		 * isn't changed
+		 */
+		rfkill_set_hw_state(kim_gdata->rfkill[ST_BT], 1);
+#endif
+		/* Configure BT nShutdown to HIGH state */
+		gpio_set_value(kim_gdata->gpios[ST_BT], GPIO_LOW);
+		mdelay(5);	/* FIXME: a proper toggle */
+		gpio_set_value(kim_gdata->gpios[ST_BT], GPIO_HIGH);
+		mdelay(100);
+		/* re-initialize the completion */
+		INIT_COMPLETION(kim_gdata->ldisc_installed);
+#ifndef LEGACY_RFKILL_SUPPORT
+		/* send signal to UIM */
+		err = kill_pid(find_get_pid(kim_gdata->uim_pid), SIGUSR2, 0);
+		if (err != 0) {
+			pr_info(" sending SIGUSR2 to uim failed %ld", err);
+			err = ST_ERR_FAILURE;
+			continue;
+		}
+#else
+		/* unblock and send event to UIM via /dev/rfkill */
+		rfkill_set_hw_state(kim_gdata->rfkill[ST_BT], 0);
+#endif
+		/* wait for ldisc to be installed */
+		err = wait_for_completion_timeout(&kim_gdata->ldisc_installed,
+				msecs_to_jiffies(LDISC_TIME));
+		if (!err) {	/* timeout */
+			pr_err("line disc installation timed out ");
+			err = ST_ERR_FAILURE;
+			continue;
+		} else {
+			/* ldisc installed now */
+			pr_info(" line discipline installed ");
+			err = download_firmware();
+			if (err != ST_SUCCESS) {
+				pr_err("download firmware failed");
+				continue;
+			} else {	/* on success don't retry */
+				break;
+			}
+		}
+	} while (retry--);
+	return err;
+}
+
+/* called from ST Core, on the last un-registration
+*/
+long st_kim_stop(void)
+{
+	long err = ST_SUCCESS;
+
+	INIT_COMPLETION(kim_gdata->ldisc_installed);
+#ifndef LEGACY_RFKILL_SUPPORT
+	/* send signal to UIM */
+	err = kill_pid(find_get_pid(kim_gdata->uim_pid), SIGUSR2, 1);
+	if (err != 0) {
+		pr_err("sending SIGUSR2 to uim failed %ld", err);
+		return ST_ERR_FAILURE;
+	}
+#else
+	/* set BT rfkill to be blocked */
+	err = rfkill_set_hw_state(kim_gdata->rfkill[ST_BT], 1);
+#endif
+
+	/* wait for ldisc to be un-installed */
+	err = wait_for_completion_timeout(&kim_gdata->ldisc_installed,
+			msecs_to_jiffies(LDISC_TIME));
+	if (!err) {		/* timeout */
+		pr_err(" timed out waiting for ldisc to be un-installed");
+		return ST_ERR_FAILURE;
+	}
+
+	/* By default configure BT nShutdown to LOW state */
+	gpio_set_value(kim_gdata->gpios[ST_BT], GPIO_LOW);
+	mdelay(1);
+	gpio_set_value(kim_gdata->gpios[ST_BT], GPIO_HIGH);
+	mdelay(1);
+	gpio_set_value(kim_gdata->gpios[ST_BT], GPIO_LOW);
+	return err;
+}
+
+/**********************************************************************/
+/* functions called from subsystems */
+
+#ifndef LEGACY_RFKILL_SUPPORT
+/* called when sysfs entry is written to */
+static ssize_t store_pid(struct device *dev, struct device_attribute
+			 *devattr, char *buf, size_t count)
+{
+	pr_info("%s: pid %s ", __func__, buf);
+	sscanf(buf, "%ld", &kim_gdata->uim_pid);
+	/* to be made use by kim_start to signal SIGUSR2
+	 */
+	return strlen(buf);
+}
+
+/* called when sysfs entry is read from */
+static ssize_t show_pid(struct device *dev, struct device_attribute
+			*attr, char *buf)
+{
+	sprintf(buf, "%ld", kim_gdata->uim_pid);
+	return strlen(buf);
+}
+
+/* called when sysfs entry is read from */
+static ssize_t show_list(struct device *dev, struct device_attribute
+			 *attr, char *buf)
+{
+	kim_st_list_protocols(kim_gdata->core_data, buf);
+	return strlen(buf);
+}
+
+#else /* LEGACY_RFKILL_SUPPORT */
+
+/* function called from rfkill subsystem, when someone from
+ * user space would write 0/1 on the sysfs entry
+ * /sys/class/rfkill/rfkill0,1,3/state
+ */
+static int kim_toggle_radio(void *data, bool blocked)
+{
+	enum proto_type type = *((enum proto_type *)data);
+	pr_info(" %s: %d ", __func__, type);
+
+	switch (type) {
+	case ST_BT:
+		/* do nothing */
+	break;
+	case ST_FM:
+	case ST_GPS:
+		if (blocked)
+			st_kim_chip_toggle(type, KIM_GPIO_INACTIVE);
+		else
+			st_kim_chip_toggle(type, KIM_GPIO_ACTIVE);
+	break;
+	case ST_MAX:
+		pr_err(" wrong proto type ");
+	break;
+	}
+	return ST_SUCCESS;
+}
+
+#endif	/* LEGACY_RFKILL_SUPPORT */
+
+void st_kim_ref(struct st_data_s **core_data)
+{
+	*core_data = kim_gdata->core_data;
+}
+
+/**********************************************************************/
+/* functions called from platform device driver subsystem
+ * need to have a relevant platform device entry in the platform's
+ * board-*.c file
+ */
+
+static int kim_probe(struct platform_device *pdev)
+{
+	long status;
+	long proto;
+	long *gpios = pdev->dev.platform_data;
+
+	status = st_core_init(&kim_gdata->core_data);
+	if (status != 0) {
+		pr_err(" ST core init failed");
+		return ST_ERR_FAILURE;
+	}
+
+	for (proto = 0; proto < ST_MAX; proto++) {
+		kim_gdata->gpios[proto] = gpios[proto];
+		pr_info(" %ld gpio to be requested", gpios[proto]);
+	}
+
+	for (proto = 0; (proto < ST_MAX) && (gpios[proto] != -1); proto++) {
+		/* Claim the Bluetooth/FM/GPIO
+		 * nShutdown gpio from the system
+		 */
+		status = gpio_request(gpios[proto], "kim");
+		if (unlikely(status)) {
+			pr_err(" gpio %ld request failed ", gpios[proto]);
+			proto -= 1;
+			while (proto >= 0) {
+				if (gpios[proto] != -1)
+					gpio_free(gpios[proto]);
+			}
+			return status;
+		}
+
+		/* Configure nShutdown GPIO as output=0 */
+		status =
+		    gpio_direction_output(gpios[proto], 0);
+		if (unlikely(status)) {
+			pr_err(" unable to configure gpio %ld",
+				   gpios[proto]);
+			proto -= 1;
+			while (proto >= 0) {
+				if (gpios[proto] != -1)
+					gpio_free(gpios[proto]);
+			}
+			return status;
+		}
+	}
+#ifndef LEGACY_RFKILL_SUPPORT
+	/* pdev to contain BT, FM and GPS enable/N-Shutdown GPIOs
+	 * execute request_gpio, set output direction
+	 */
+	kim_gdata->kim_kobj = kobject_create_and_add("uim", NULL);
+	/* create the sysfs entry for UIM to put in pid */
+	if (sysfs_create_group(kim_gdata->kim_kobj, &uim_attr_grp)) {
+		pr_err(" sysfs entry creation failed");
+		kobject_put(kim_gdata->kim_kobj);
+		/* free requested GPIOs and fail probe */
+		for (proto = ST_BT; proto < ST_MAX; proto++) {
+			if (gpios[proto] != -1)
+				gpio_free(gpios[proto]);
+		}
+		return -1;	/* fail insmod */
+	}
+	pr_info(" sysfs entry created ");
+#endif
+	/* get reference of pdev for request_firmware
+	 */
+	kim_gdata->kim_pdev = pdev;
+	init_completion(&kim_gdata->kim_rcvd);
+	init_completion(&kim_gdata->ldisc_installed);
+#ifdef LEGACY_RFKILL_SUPPORT
+	for (proto = 0; (proto < ST_MAX) && (gpios[proto] != -1); proto++) {
+		/* TODO: should all types be rfkill_type_bt ? */
+		kim_gdata->rf_protos[proto] = proto;
+		kim_gdata->rfkill[proto] = rfkill_alloc(protocol_names[proto],
+			&pdev->dev, RFKILL_TYPE_BLUETOOTH,
+			&kim_rfkill_ops, &kim_gdata->rf_protos[proto]);
+		if (kim_gdata->rfkill[proto] == NULL) {
+			pr_err("cannot create rfkill entry for gpio %ld",
+				   gpios[proto]);
+			continue;
+		}
+		/* block upon creation */
+		rfkill_init_sw_state(kim_gdata->rfkill[proto], 1);
+		status = rfkill_register(kim_gdata->rfkill[proto]);
+		if (unlikely(status)) {
+			pr_err("rfkill registration failed for gpio %ld",
+				   gpios[proto]);
+			rfkill_unregister(kim_gdata->rfkill[proto]);
+			continue;
+		}
+		pr_info("rfkill entry created for %ld", gpios[proto]);
+	}
+#endif
+	return ST_SUCCESS;
+}
+
+static int kim_remove(struct platform_device *pdev)
+{
+	/* free the GPIOs requested
+	 */
+	long *gpios = pdev->dev.platform_data;
+	long proto;
+
+	for (proto = 0; (proto < ST_MAX) && (gpios[proto] != -1); proto++) {
+		/* Claim the Bluetooth/FM/GPIO
+		 * nShutdown gpio from the system
+		 */
+		gpio_free(gpios[proto]);
+#ifdef LEGACY_RFKILL_SUPPORT
+		rfkill_unregister(kim_gdata->rfkill[proto]);
+		rfkill_destroy(kim_gdata->rfkill[proto]);
+		kim_gdata->rfkill[proto] = NULL;
+#endif
+	}
+	pr_info("kim: GPIO Freed");
+#ifndef LEGACY_RFKILL_SUPPORT
+	/* delete the sysfs entries */
+	sysfs_remove_group(kim_gdata->kim_kobj, &uim_attr_grp);
+	kobject_put(kim_gdata->kim_kobj);
+#endif
+	kim_gdata->kim_pdev = NULL;
+	st_core_exit(kim_gdata->core_data);
+	return ST_SUCCESS;
+}
+
+/**********************************************************************/
+/* entry point for ST KIM module, called in from ST Core */
+
+static int __init st_kim_init(void)
+{
+	long ret = ST_SUCCESS;
+	kim_gdata = kzalloc(sizeof(struct kim_data_s), GFP_ATOMIC);
+	if (!kim_gdata) {
+		pr_err("no mem to allocate");
+		return -ENOMEM;
+	}
+
+	ret = platform_driver_register(&kim_platform_driver);
+	if (ret != 0) {
+		pr_err("platform drv registration failed");
+		return ST_ERR_FAILURE;
+	}
+	return ST_SUCCESS;
+}
+
+static void __exit st_kim_deinit(void)
+{
+	/* the following returns void */
+	platform_driver_unregister(&kim_platform_driver);
+	kfree(kim_gdata);
+	kim_gdata = NULL;
+}
+
+
+module_init(st_kim_init);
+module_exit(st_kim_deinit);
+MODULE_AUTHOR("Pavan Savoy <pavan_savoy@ti.com>");
+MODULE_DESCRIPTION("Shared Transport Driver for TI BT/FM/GPS combo chips ");
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/ti-st/st_kim.h b/drivers/staging/ti-st/st_kim.h
new file mode 100644
index 0000000..ff3270e
--- /dev/null
+++ b/drivers/staging/ti-st/st_kim.h
@@ -0,0 +1,150 @@
+/*
+ *  Shared Transport Line discipline driver Core
+ *	Init Manager Module header file
+ *  Copyright (C) 2009 Texas Instruments
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#ifndef ST_KIM_H
+#define ST_KIM_H
+
+#include <linux/types.h>
+#include "st.h"
+#include "st_core.h"
+#include "st_ll.h"
+#include <linux/rfkill.h>
+
+/* time in msec to wait for
+ * line discipline to be installed
+ */
+#define LDISC_TIME	500
+#define CMD_RESP_TIME	500
+#define MAKEWORD(a, b)  ((unsigned short)(((unsigned char)(a)) \
+	| ((unsigned short)((unsigned char)(b))) << 8))
+
+#define GPIO_HIGH 1
+#define GPIO_LOW  0
+
+/* the Power-On-Reset logic, requires to attempt
+ * to download firmware onto chip more than once
+ * since the self-test for chip takes a while
+ */
+#define POR_RETRY_COUNT 5
+/*
+ * legacy rfkill support where-in 3 rfkill
+ * devices are created for the 3 gpios
+ * that ST has requested
+ */
+#define LEGACY_RFKILL_SUPPORT
+/*
+ * header file for ST provided by KIM
+ */
+struct kim_data_s {
+	long uim_pid;
+	struct platform_device *kim_pdev;
+	struct completion kim_rcvd, ldisc_installed;
+	/* MAX len of the .bts firmware script name */
+	char resp_buffer[30];
+	const struct firmware *fw_entry;
+	long gpios[ST_MAX];
+	struct kobject *kim_kobj;
+/* used by kim_int_recv to validate fw response */
+	unsigned long rx_state;
+	unsigned long rx_count;
+	struct sk_buff *rx_skb;
+#ifdef LEGACY_RFKILL_SUPPORT
+	struct rfkill *rfkill[ST_MAX];
+	enum proto_type rf_protos[ST_MAX];
+#endif
+	struct st_data_s *core_data;
+};
+
+long st_kim_start(void);
+long st_kim_stop(void);
+/*
+ * called from st_tty_receive to authenticate fw_download
+ */
+void st_kim_recv(void *, const unsigned char *, long count);
+
+void st_kim_chip_toggle(enum proto_type, enum kim_gpio_state);
+
+void st_kim_complete(void);
+
+/* function called from ST KIM to ST Core, to
+ * list out the protocols registered
+ */
+void kim_st_list_protocols(struct st_data_s *, char *);
+
+/*
+ * BTS headers
+ */
+#define ACTION_SEND_COMMAND     1
+#define ACTION_WAIT_EVENT       2
+#define ACTION_SERIAL           3
+#define ACTION_DELAY            4
+#define ACTION_RUN_SCRIPT       5
+#define ACTION_REMARKS          6
+
+/*
+ *  * BRF Firmware header
+ *   */
+struct bts_header {
+	uint32_t magic;
+	uint32_t version;
+	uint8_t future[24];
+	uint8_t actions[0];
+} __attribute__ ((packed));
+
+/*
+ *  * BRF Actions structure
+ *   */
+struct bts_action {
+	uint16_t type;
+	uint16_t size;
+	uint8_t data[0];
+} __attribute__ ((packed));
+
+struct bts_action_send {
+	uint8_t data[0];
+} __attribute__ ((packed));
+
+struct bts_action_wait {
+	uint32_t msec;
+	uint32_t size;
+	uint8_t data[0];
+} __attribute__ ((packed));
+
+struct bts_action_delay {
+	uint32_t msec;
+} __attribute__ ((packed));
+
+struct bts_action_serial {
+	uint32_t baud;
+	uint32_t flow_control;
+} __attribute__ ((packed));
+
+/* for identifying the change speed HCI VS
+ * command
+ */
+struct hci_command {
+	uint8_t prefix;
+	uint16_t opcode;
+	uint8_t plen;
+	uint32_t speed;
+} __attribute__ ((packed));
+
+
+#endif /* ST_KIM_H */
-- 
1.5.4.3






> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


      The INTERNET now has a personality. YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
