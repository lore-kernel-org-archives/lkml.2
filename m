Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566Ab1EYAEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 20:04:36 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:43805 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933002Ab1EYAEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 20:04:35 -0400
Date: Wed, 25 May 2011 02:03:02 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Wei Wang <wei_wang@realsil.com.cn>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rts_pstor: use bitwise operator instead of logical
 one
Message-ID: <20110525020302.7540c71f@absol.kitzblitz>
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

Looks like a typo?

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/staging/rts_pstor/sd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index bddb031..cdae497 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -2328,7 +2328,7 @@ Switch_Fail:
 
 			retval = sd_send_cmd_get_rsp(chip, IO_SEND_OP_COND, 0, SD_RSP_TYPE_R4, rsp, 5);
 			if (retval == STATUS_SUCCESS) {
-				int func_num = (rsp[1] >> 4) && 0x07;
+				int func_num = (rsp[1] >> 4) & 0x07;
 				if (func_num) {
 					RTSX_DEBUGP("SD_IO card (Function number: %d)!\n", func_num);
 					chip->sd_io = 1;
-- 
1.7.5.rc3
