Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab1GCLUi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 07:20:38 -0400
Received: from platinum.liacs.nl ([132.229.131.22]:50059 "EHLO
	platinum.liacs.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab1GCLUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 07:20:36 -0400
Date: Sun, 3 Jul 2011 13:15:44 +0200
From: J Witteveen <jwitteve@liacs.nl>
To: linux-kernel@vger.kernel.org
Cc: mjg@redhat.com, gregkh@suse.de, platform-driver-x86@vger.kernel.org
Subject: [PATCH] Samsung Laptop platform driver: support N510
Message-ID: <20110703111544.GA21626@liacs.nl>
Reply-To: j.witteveen@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (platinum.liacs.nl [132.229.131.22]); Sun, 03 Jul 2011 13:15:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

It appears my previous message has gone unnoticed.
This is my second shot. The patch below adds the N510 netbook to the list of supported hardware.

Regards,
- Jouke


----- Forwarded message from J Witteveen <jwitteve@liacs.nl> -----

Date: Sun, 26 Jun 2011 17:08:55 +0200
From: J Witteveen <jwitteve@liacs.nl>
To: mjg@redhat.com
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Bcc: j.witteveen@gmail.com
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 11, 2011 at 10:17, Jouke Witteveen <j.witteveen@gmail.com> wrote:
> On Wed, Feb 9, 2011 at 23:40, Greg KH <greg@kroah.com> wrote:
>> From: Greg Kroah-Hartman <gregkh@suse.de>
>>
>> This adds the samsung-laptop driver to the kernel.  It now supports
>> all known Samsung laptops.
>>
>
> I don't see the N510, is this intentional? The netbook does not differ
> that much from some that are included.
>

The N510 benefits from this code as well. Below is a patch to include support.

Signed-off-by: Jouke Witteveen <j.witteveen@gmail.com>

Thanks,
- Jouke

--- a/drivers/platform/x86/samsung-laptop.c	2011-06-26 16:18:06.517840468 +0200
+++ b/drivers/platform/x86/samsung-laptop.c	2011-06-26 16:19:14.677574644 +0200
@@ -521,6 +521,16 @@ static struct dmi_system_id __initdata s
 		.callback = dmi_check_cb,
 	},
 	{
+		.ident = "N510",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR,
+					"SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "N510"),
+			DMI_MATCH(DMI_BOARD_NAME, "N510"),
+		},
+		.callback = dmi_check_cb,
+	},
+	{
 		.ident = "X125",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR,


----- End forwarded message -----
