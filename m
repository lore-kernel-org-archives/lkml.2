Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab0CWWMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 18:12:39 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:63245 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab0CWWMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 18:12:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=XJxIsJnPfSI+PLPVop6ESF5BmgPCThQnbw771ejaKLdubZ5IJ4a1q+5r8K3Vb9G/6Z
         vKiurDnejfg9ky6dKzdEoerqMLFgZrIzmEZmm5JRr4Mmt72yn+AWd1yQ7plFKWvQLzKC
         eM5QoIk5g296cpq28V/KqCMpLnggDrjWdZhs8=
Message-ID: <4BA93CD1.5060501@gmail.com>
Date: Tue, 23 Mar 2010 23:12:33 +0100
From: =?ISO-8859-15?Q?Steffen_R=F6cker?= <sroecker@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100322 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Richard Purdie <rpurdie@linux.intel.com>
Subject: [PATCH] backlight: mbp_nvidia_bl - Fix DMI_SYS_VENDOR for MacBook1,1
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix DMI_SYS_VENDOR for MacBook1,1.

When the MacBook1,1 came out Apple was still named Apple Computer, I am 
not sure if this applies to older MacBook2,1 versions aswell.

Signed-off-by: Steffen Röcker <sroecker@gmail.com>
---
  drivers/video/backlight/mbp_nvidia_bl.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/mbp_nvidia_bl.c 
b/drivers/video/backlight/mbp_nvidia_bl.c
index 1b5d3fe..08ffada 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -141,7 +141,7 @@ static const struct dmi_system_id __initdata 
mbp_device_table[] = {
                 .callback       = mbp_dmi_match,
                 .ident          = "MacBook 1,1",
                 .matches        = {
-                       DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+                       DMI_MATCH(DMI_SYS_VENDOR, "Apple Computer, Inc."),
                         DMI_MATCH(DMI_PRODUCT_NAME, "MacBook1,1"),
                 },
                 .driver_data    = (void *)&intel_chipset_data,
-- 
1.7.0

