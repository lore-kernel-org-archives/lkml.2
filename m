Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab1F0VGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 17:06:49 -0400
Received: from platinum.liacs.nl ([132.229.131.22]:49909 "EHLO
	platinum.liacs.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab1F0VGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 17:06:41 -0400
X-Greylist: delayed 107553 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jun 2011 17:06:40 EDT
Date: Sun, 26 Jun 2011 17:08:55 +0200
From: J Witteveen <jwitteve@liacs.nl>
To: mjg@redhat.com
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
Message-ID: <20110626150855.GA19359@liacs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (platinum.liacs.nl [132.229.131.22]); Sun, 26 Jun 2011 17:09:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

