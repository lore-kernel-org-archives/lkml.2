Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab0CQCLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 22:11:24 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:59623 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab0CQCLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 22:11:23 -0400
Message-ID: <4BA03A1A.50204@murgatroid.com>
Date: Tue, 16 Mar 2010 19:10:34 -0700
From: Christopher Hoover <ch@murgatroid.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.8) Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Patch for B&B Electronics USPLT4-LS
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for B&B Electronics USPLT4-LS.

Cheers,
Christopher.

-ch
ch@murgatroid.com

diff --exclude='*~' -Naur linux-2.6.30.orig/drivers/usb/serial/ftdi_sio.c linux-2.6.30/drivers/usb/serial/ftdi_sio.c
--- linux-2.6.30.orig/drivers/usb/serial/ftdi_sio.c	2009-06-09 20:05:27.000000000 -0700
+++ linux-2.6.30/drivers/usb/serial/ftdi_sio.c	2010-03-16 09:24:34.000000000 -0700
@@ -587,6 +587,7 @@
  	{ USB_DEVICE(BANDB_VID, BANDB_USOTL4_PID) },
  	{ USB_DEVICE(BANDB_VID, BANDB_USTL4_PID) },
  	{ USB_DEVICE(BANDB_VID, BANDB_USO9ML2_PID) },
+	{ USB_DEVICE(BANDB_VID, BANDB_USPTL4LS_PID) },
  	{ USB_DEVICE(FTDI_VID, EVER_ECO_PRO_CDS) },
  	{ USB_DEVICE(FTDI_VID, FTDI_4N_GALAXY_DE_1_PID) },
  	{ USB_DEVICE(FTDI_VID, FTDI_4N_GALAXY_DE_2_PID) },
diff --exclude='*~' -Naur linux-2.6.30.orig/drivers/usb/serial/ftdi_sio.h linux-2.6.30/drivers/usb/serial/ftdi_sio.h
--- linux-2.6.30.orig/drivers/usb/serial/ftdi_sio.h	2009-06-09 20:05:27.000000000 -0700
+++ linux-2.6.30/drivers/usb/serial/ftdi_sio.h	2010-03-16 09:24:05.000000000 -0700
@@ -651,6 +651,7 @@
  #define BANDB_USOTL4_PID	0xAC01	/* USOTL4 Isolated RS-485 Converter */
  #define BANDB_USTL4_PID		0xAC02	/* USTL4 RS-485 Converter */
  #define BANDB_USO9ML2_PID	0xAC03	/* USO9ML2 Isolated RS-232 Converter */
+#define BANDB_USPTL4LS_PID	0xAC12  /* USPTL4-LS RS-422/485 Adapter */

  /*
   * RM Michaelides CANview USB (http://www.rmcan.com)


