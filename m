Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911Ab2EDUpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:45:01 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:45099 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759891Ab2EDUo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:44:57 -0400
Message-Id: <20120504204226.094841068@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:42:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Martin Nyhus <martin.nyhus@gmx.com>,
        Matthew Garrett <mjg@redhat.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jens Gustedt <Jens.Gustedt@loria.fr>
Subject: [ 20/75] dell-laptop: Terminate quirks list properly
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Nyhus <martin.nyhus@gmx.com>

commit d62d421b071b08249361044d8e56c8b5c3ed6aa7 upstream.

Add missing DMI_NONE entry to end of the quirks list so
dmi_check_system() won't read past the end of the list.

Signed-off-by: Martin Nyhus <martin.nyhus@gmx.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Tested-by: Jens Gustedt <Jens.Gustedt@loria.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/dell-laptop.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -211,6 +211,7 @@ static struct dmi_system_id __devinitdat
 		},
 		.driver_data = &quirk_dell_vostro_v130,
 	},
+	{ }
 };
 
 static struct calling_interface_buffer *buffer;


