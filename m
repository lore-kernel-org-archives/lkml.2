Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab1BPBte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:49:34 -0500
Received: from kroah.org ([198.145.64.141]:48774 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab1BPBt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:49:27 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:56 2011
Message-Id: <20110216014656.499289781@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:44:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Arvid Ephraim Picciani <arvid.picciani@nokia.com>
Subject: [022/115] USB: cdc-acm: Adding second ACM channel support for Nokia N8
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Arvid Ephraim Picciani <arvid.picciani@nokia.com>

commit 721d92fc6373dee15846216f9d178ec240ec0fd7 upstream.

This adds the N8 to the list of devices in cdc-acm, in order to get the
secondary ACM device exposed.

In the spirit of:
http://kerneltrap.org/mailarchive/linux-usb/2010/9/4/6264554

Signed-off-by: Arvid Ephraim Picciani <arvid.picciani@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1596,6 +1596,7 @@ static struct usb_device_id acm_ids[] =
 	{ NOKIA_PCSUITE_ACM_INFO(0x0154), }, /* Nokia 5800 XpressMusic */
 	{ NOKIA_PCSUITE_ACM_INFO(0x04ce), }, /* Nokia E90 */
 	{ NOKIA_PCSUITE_ACM_INFO(0x01d4), }, /* Nokia E55 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x0302), }, /* Nokia N8 */
 	{ SAMSUNG_PCSUITE_ACM_INFO(0x6651), }, /* Samsung GTi8510 (INNOV8) */
 
 	/* NOTE: non-Nokia COMM/ACM/0xff is likely MSFT RNDIS... NOT a modem! */


