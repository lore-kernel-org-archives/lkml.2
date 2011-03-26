Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934472Ab1CZBuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:50:54 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50619 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934248Ab1CZBu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:50:27 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/zGOoJdCbzGJSF+jszt4NXQFTlWwcTOoxe+BvyrB
	BBkTbPDp2fAdB7
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 25/27] staging/westbridge: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:50:00 +0100
Message-Id: <1301104202-16592-25-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301104202-16592-23-git-send-email-peterhuewe@gmx.de>
References: <1301104202-16592-23-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some very common spelling mistakes in
drivers/staging/westbridge.

WRONG -> RIGHT
recieve     -> receive
requst		-> request
reqest		-> request
interrrupt	-> interrupt
percieve	-> perceive

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 .../westbridge/astoria/api/src/cyaslowlevel.c      |    2 +-
 .../staging/westbridge/astoria/api/src/cyasmisc.c  |    4 +-
 .../westbridge/astoria/block/cyasblkdev_block.c    |    2 +-
 .../westbridge/astoria/block/cyasblkdev_queue.c    |    2 +-
 .../astoria/include/linux/westbridge/cyasstorage.h |   22 ++++++++++----------
 .../astoria/include/linux/westbridge/cyasusb_dep.h |    2 +-
 6 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c b/drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c
index d43dd85..5573533 100644
--- a/drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c
+++ b/drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c
@@ -678,7 +678,7 @@ cy_as_read_intr_status(
 		/*
 		* queue the mailbox data for later processing.
 		* this allows the firmware to move forward and
-		* service the requst from the P port.
+		* service the request from the P port.
 		*/
 		cy_as_ll_queue_mailbox_data(dev_p);
 
diff --git a/drivers/staging/westbridge/astoria/api/src/cyasmisc.c b/drivers/staging/westbridge/astoria/api/src/cyasmisc.c
index 7852410..5748ae6 100644
--- a/drivers/staging/westbridge/astoria/api/src/cyasmisc.c
+++ b/drivers/staging/westbridge/astoria/api/src/cyasmisc.c
@@ -428,7 +428,7 @@ my_misc_callback(cy_as_device *dev_p, uint8_t context,
 				if (v & CY_AS_MEM_P0_VM_SET_CFGMODE)
 					cy_as_hal_print_message(
 					"initialization message "
-					"recieved, but config bit "
+					"received, but config bit "
 					"still set\n");
 
 				v = cy_as_hal_read_register(dev_p->tag,
@@ -436,7 +436,7 @@ my_misc_callback(cy_as_device *dev_p, uint8_t context,
 				if ((v & CY_AS_MEM_RST_RSTCMPT) == 0)
 					cy_as_hal_print_message(
 					"initialization message "
-					"recieved, but reset complete "
+					"received, but reset complete "
 					"bit still not set\n");
 			}
 			break;
diff --git a/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c b/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
index e1851f0..43cef26 100644
--- a/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
+++ b/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
@@ -117,7 +117,7 @@ struct cyasblkdev_blk_data {
 	 * 16 * 4K (64 K per request)*/
 	struct scatterlist	  sg[16];
 
-	/* non-zero enables printk of executed reqests */
+	/* non-zero enables printk of executed requests */
 	unsigned int	dbgprn_flags;
 
 	/*gen_disk for private, system disk */
diff --git a/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c b/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c
index 0bbb8a3..d1996a2 100644
--- a/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c
+++ b/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c
@@ -222,7 +222,7 @@ static int cyasblkdev_queue_thread(void *d)
 			continue;
 		}
 
-		/* new req recieved, issue it to the driver  */
+		/* new req received, issue it to the driver  */
 		set_current_state(TASK_RUNNING);
 
 		#ifndef WESTBRIDGE_NDEBUG
diff --git a/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage.h b/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage.h
index 64f078c..d1bbac4 100644
--- a/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage.h
+++ b/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage.h
@@ -297,7 +297,7 @@ typedef enum cy_as_storage_event {
 	cy_as_storage_inserted,
 
 	/* This event occurs when the West Bridge device
-	 * percieves an interrrupt from an SDIO card */
+	 * perceives an interrupt from an SDIO card */
 	cy_as_sdio_interrupt
 
 } cy_as_storage_event;
@@ -1985,7 +1985,7 @@ cy_as_storage_erase(
    *	type was made
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
    * CY_AS_ERROR_INVALID_RESPONSE - an error message was
-   *	recieved from the firmware
+   *	received from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error in
    *	reading from the media
    * CY_AS_ERROR_INVALID_FUNCTION - An IO attempt was made to
@@ -2047,7 +2047,7 @@ cy_as_sdio_get_c_i_s_info(
    *	pair does not exist
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
    * CY_AS_ERROR_INVALID_RESPONSE - an error message was
-   *	recieved from the firmware
+   *	received from the firmware
 
 */
 cy_as_return_status_t
@@ -2095,7 +2095,7 @@ cy_as_sdio_query_card(
    *	pair does not exist
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
    * CY_AS_ERROR_INVALID_RESPONSE - an error message was
-   *	recieved from the firmware
+   *	received from the firmware
    */
 cy_as_return_status_t
 cy_as_sdio_reset_card(
@@ -2139,7 +2139,7 @@ cy_as_sdio_reset_card(
    * CY_AS_ERROR_NO_SUCH_DEVICE - the specified media/device pair
    *	does not exist
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
-   * CY_AS_ERROR_INVALID_RESPONSE - an error message was recieved
+   * CY_AS_ERROR_INVALID_RESPONSE - an error message was received
    *	from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error in reading
    *	from the media
@@ -2198,7 +2198,7 @@ cy_as_sdio_direct_read(
    * CY_AS_ERROR_NO_SUCH_DEVICE - the specified media/device
    * pair does not exist
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
-   * CY_AS_ERROR_INVALID_RESPONSE - an error message was recieved
+   * CY_AS_ERROR_INVALID_RESPONSE - an error message was received
    * from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error in
    * reading from the media
@@ -2262,7 +2262,7 @@ cy_as_sdio_direct_write(
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory
    *	available
    * CY_AS_ERROR_INVALID_RESPONSE - an error message was
-   *	recieved from the firmware
+   *	received from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error in
    *	reading from the media
    * CY_AS_ERROR_INVALID_FUNCTION - An IO attempt was made
@@ -2319,7 +2319,7 @@ cy_as_sdio_set_blocksize(
    *	pair does not exist
    * CY_AS_ERROR_ASYNC_PENDING - an async operation is pending
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
-   * CY_AS_ERROR_INVALID_RESPONSE - an error message was recieved
+   * CY_AS_ERROR_INVALID_RESPONSE - an error message was received
    *	from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error in
    *	reading from the media
@@ -2396,7 +2396,7 @@ cy_as_sdio_extended_read(
    * CY_AS_ERROR_ASYNC_PENDING - an async operation is pending
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
    * CY_AS_ERROR_INVALID_RESPONSE - an error message was
-   *	recieved from the firmware
+   *	received from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error in
    *	reading from the media
    * CY_AS_ERROR_INVALID_FUNCTION - An IO attempt was made
@@ -2471,7 +2471,7 @@ cy_as_sdio_extended_write(
    * pair does not exist
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
    * CY_AS_ERROR_INVALID_RESPONSE - an error message was
-   *	recieved from the firmware
+   *	received from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error in
    *	reading from the media
    * CY_AS_ERROR_INVALID_FUNCTION - An IO attempt was made
@@ -2714,7 +2714,7 @@ cy_as_sdio_suspend(
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory
    *	available
    * CY_AS_ERROR_INVALID_RESPONSE - an error message was
-   *	recieved from the firmware
+   *	received from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error
    *	in reading from the media
    * CY_AS_ERROR_INVALID_FUNCTION - An IO attempt was
diff --git a/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasusb_dep.h b/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasusb_dep.h
index 829edde..97fe8b2 100644
--- a/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasusb_dep.h
+++ b/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasusb_dep.h
@@ -55,7 +55,7 @@ typedef struct cy_as_usb_inquiry_data_dep {
 typedef struct cy_as_usb_unknown_command_data_dep {
 	/* The media for the event */
 	cy_as_media_type media;
-	/* The length of the requst (should be 16 bytes) */
+	/* The length of the request (should be 16 bytes) */
 	uint16_t reqlen;
 	/* The request */
 	void *request;
-- 
1.7.3.4

