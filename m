Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab2JPHa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:30:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25491 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab2JPHa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:30:57 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-c8-507d0d301b12
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
In-reply-to: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
Subject: [PATCH 10/17] backlight: lm3630: fix checkpatch warning
Date: Tue, 16 Oct 2012 16:30:56 +0900
Message-id: <007b01cdab70$2e54d210$8afe7630$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rb2x3b+BtYCwlRU+aka06gjxy+QAALOqg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jQV0D3toAg8fPdC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGjwv72AqesFX8aeliamA8y9rFyMkhIWAicbzvMzuELSZx4d56
	ti5GLg4hgemMEsseHmOBcGYzSXT/OQPWwSagJvHly2GwDhGBCInmGbOYuxg5OJgFfCQ2z9IE
	CQsJ2EqsnvEWrIRTwE5i4+uDLCC2sICDxKwtv9hAbBYBVYnjK2+xgrTyAtV/b1QBCfMKCEr8
	mHwPrJxZQEti/c7jTBC2vMTmNW/BNkkIqEs8+qsLcYCRRNuqdVAlIhL7XrxjnMAoNAvJpFlI
	Js1CMmkWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYKD+JnUDsaVDRaHGAU4GJV4
	eDOcawKEWBPLiitzDzFKcDArifB6TAQK8aYkVlalFuXHF5XmpBYfYpTmYFES5232SAkQEkhP
	LEnNTk0tSC2CyTJxcEo1MC68EvbBofRTr+7s32mtVYGP5nH4nbkd0XVopv7jTY07N6/8a6x9
	caWU+7M1MzKfudw+/S7l3LrVNXPL/iZ/2BareLZJOPgbk4jZnoAfaf+uPX/xx7Ml493s3Jk9
	Wodnt/rXNbsZXjae4zD1xMGaH20To99/2KmzpGp3Z8hz78xb2+68+pwv1FmpxFKckWioxVxU
	nAgAiAJBx14CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch warning as below:

WARNING: static const char * array should probably be static const char * const

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/lm3630_bl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/lm3630_bl.c b/drivers/video/backlight/lm3630_bl.c
index dc19144..a56f6a8 100644
--- a/drivers/video/backlight/lm3630_bl.c
+++ b/drivers/video/backlight/lm3630_bl.c
@@ -37,7 +37,7 @@ enum lm3630_leds {
 	BLED_2
 };
 
-static const char *bled_name[] = {
+static const char * const bled_name[] = {
 	[BLED_ALL] = "lm3630_bled",	/*Bank1 controls all string */
 	[BLED_1] = "lm3630_bled1",	/*Bank1 controls bled1 */
 	[BLED_2] = "lm3630_bled2",	/*Bank1 or 2 controls bled2 */
-- 
1.7.1


