Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab2EIGPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:15:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38976 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756355Ab2EIFx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:29 -0400
Message-Id: <20120509055044.241169025@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:14 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Martin Nyhus <martin.nyhus@gmx.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [ 105/167] [PATCH] dell-laptop: Terminate quirks list properly
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Nyhus <martin.nyhus@gmx.com>

commit d62d421b071b08249361044d8e56c8b5c3ed6aa7 upstream.

Add missing DMI_NONE entry to end of the quirks list so
dmi_check_system() won't read past the end of the list.

Signed-off-by: Martin Nyhus <martin.nyhus@gmx.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/platform/x86/dell-laptop.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index a05fc9c..e6c08ee 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -212,6 +212,7 @@ static struct dmi_system_id __devinitdata dell_quirks[] = {
 		},
 		.driver_data = &quirk_dell_vostro_v130,
 	},
+	{ }
 };
 
 static struct calling_interface_buffer *buffer;
-- 
1.7.10



