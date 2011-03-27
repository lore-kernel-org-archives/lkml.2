Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab1C0Pzi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 11:55:38 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:46030 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753918Ab1C0PzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 11:55:21 -0400
Date: Sun, 27 Mar 2011 17:48:53 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jarod Wilson <jarod@wilsonet.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: crystalhd: remove unused typedef bc_bool_t
Message-ID: <20110327174853.5e9ea61b@absol.kitzblitz>
Organization: -
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAAXNSR0IArs4c6QAAAAZQTFRF
 AJnV/f/88sgWwwAAAKNJREFUGNM10LENwyAQheFHKCgZgTVSRHI2gy5reROTDSiREvnyHhdXnwXS+
 T+ACJgBYTiGSmDDOTdR7XDeTi9ksxEcoKFcTOCJLO7kC5SWFjPZCR69nI9+x5u6OJM1RN5UYUiNKa
 ZRpHHUoqh1v8hKEZ1FSGCrYOvgVmxd9DIXcSJwLTycm7bj0e4wkJGB48w/FckAwUKl/OGDZAcqItk
 BU+wHXLqKsjYyPeMAAAAASUVORK5CYII=
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused typedef bc_bool_t.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/staging/crystalhd/bc_dts_types.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/crystalhd/bc_dts_types.h b/drivers/staging/crystalhd/bc_dts_types.h
index 6fd8089..d2131e7 100644
--- a/drivers/staging/crystalhd/bc_dts_types.h
+++ b/drivers/staging/crystalhd/bc_dts_types.h
@@ -65,7 +65,6 @@ typedef unsigned char	*PUCHAR;
 #else
 
 /* For Kernel usage.. */
-typedef bool	bc_bool_t;
 #endif
 
 #else
-- 
1.7.3.4
