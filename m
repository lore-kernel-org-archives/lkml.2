Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751026Ab1BJFYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 00:24:06 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46287 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab1BJFYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 00:24:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=f4/OdSMWEnuzNUzbZn/wOkURPDdTJf19oBL/18ZKIyCAf9ciZIVBW8eh3/85itf8pl
         dfcwo5Al7yDeFYixBZ8ZCbpf6eFpm24/uXpTZmYKU300u0A0r5YL1sEX3ZUArBb6osMr
         oNR0FdpFhLt3Vj0GjGwOh6JKB7Imn1nboPWb0=
Date: Thu, 10 Feb 2011 13:23:35 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com,
        davem@davemloft.net, greg@kroah.com, acme@ghostprotocols.net,
        eric.piel@tremplin-utc.net
Subject: [PATCH]Sort a Maintainer in MAINTAINERS according to alphabetical
 order
Message-ID: <20110210052330.GA5376@gmail.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	joe@perches.com, davem@davemloft.net, greg@kroah.com,
	acme@ghostprotocols.net, eric.piel@tremplin-utc.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi us,
    When i see MAINTAINERS i find a maintainer who is not in right position. So i patched for it like following :) I have also emailed to himself ;)

    Thanks.
    Best Regards.
    Harry Wei.


Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 MAINTAINERS |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3b4c67a..7e792bf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3877,6 +3877,12 @@ L:	linux-security-module@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git
 S:	Supported
 
+LIS3LV02D ACCELEROMETER DRIVER
+M:	Eric Piel <eric.piel@tremplin-utc.net>
+S:	Maintained
+F:	Documentation/hwmon/lis3lv02d
+F:	drivers/hwmon/lis3lv02d.*
+
 LLC (802.2)
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
 S:	Maintained
@@ -3884,12 +3890,6 @@ F:	include/linux/llc.h
 F:	include/net/llc*
 F:	net/llc/
 
-LIS3LV02D ACCELEROMETER DRIVER
-M:	Eric Piel <eric.piel@tremplin-utc.net>
-S:	Maintained
-F:	Documentation/hwmon/lis3lv02d
-F:	drivers/hwmon/lis3lv02d.*
-
 LM73 HARDWARE MONITOR DRIVER
 M:	Guillaume Ligneul <guillaume.ligneul@gmail.com>
 L:	lm-sensors@lm-sensors.org
-- 
1.7.0.4


