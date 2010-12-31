Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab1AAJdI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 04:33:08 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40931 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab1AAJdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 04:33:07 -0500
Message-ID: <4d1ef4d0.52790e0a.29d3.06b9@mx.google.com>
From: Abylay Ospan <liplianin@me.by>
Date: Fri, 31 Dec 2010 13:37:00 +0200
Subject: [PATCH 11/18] stv0367: change default value for AGC register.
To: <mchehab@infradead.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Abylay Ospan <aospan@netup.ru>
---
 drivers/media/dvb/frontends/stv0367.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv0367.c b/drivers/media/dvb/frontends/stv0367.c
index e6bee7f..9439388 100644
--- a/drivers/media/dvb/frontends/stv0367.c
+++ b/drivers/media/dvb/frontends/stv0367.c
@@ -286,7 +286,7 @@ static struct st_register def0367ter[STV0367TER_NBREGS] = {
 	{R367TER_PLLMDIV,	0x01},/* for xc5000; was 0x0c */
 	{R367TER_PLLNDIV,	0x06},/* for xc5000; was 0x55 */
 	{R367TER_PLLSETUP,	0x18},
-	{R367TER_DUAL_AD12,	0x04},/* for xc5000; was 0x00 */
+	{R367TER_DUAL_AD12,	0x0C},/* for xc5000 AGC voltage 1.6V */
 	{R367TER_TSTBIST,	0x00},
 	{R367TER_PAD_COMP_CTRL,	0x00},
 	{R367TER_PAD_COMP_WR,	0x00},
@@ -599,7 +599,7 @@ static struct st_register def0367cab[STV0367CAB_NBREGS] = {
 	{R367CAB_PLLMDIV,	0x01},
 	{R367CAB_PLLNDIV,	0x08},
 	{R367CAB_PLLSETUP,	0x18},
-	{R367CAB_DUAL_AD12,	0x04},
+	{R367CAB_DUAL_AD12,	0x0C}, /* for xc5000 AGC voltage 1.6V */
 	{R367CAB_TSTBIST,	0x00},
 	{R367CAB_CTRL_1,	0x00},
 	{R367CAB_CTRL_2,	0x03},
-- 
1.7.1

