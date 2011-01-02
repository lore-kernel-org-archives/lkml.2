Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1ABQtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 11:49:19 -0500
Received: from utm.netup.ru ([193.203.36.250]:57753 "EHLO utm.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab1ABQtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 11:49:17 -0500
Message-ID: <4D20ABFB.9070509@netup.ru>
Date: Sun, 02 Jan 2011 16:46:51 +0000
From: Abylay Ospan <aospan@netup.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5 v2] stv0367: change default value for AGC register.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Abylay Ospan <aospan@netup.ru>
---
  drivers/media/dvb/frontends/stv0367.c |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv0367.c 
b/drivers/media/dvb/frontends/stv0367.c
index 68d7d7d..b85b9b9 100644
--- a/drivers/media/dvb/frontends/stv0367.c
+++ b/drivers/media/dvb/frontends/stv0367.c
@@ -286,7 +286,7 @@ static struct st_register 
def0367ter[STV0367TER_NBREGS] = {
  	{R367TER_PLLMDIV,	0x01},/* for xc5000; was 0x0c */
  	{R367TER_PLLNDIV,	0x06},/* for xc5000; was 0x55 */
  	{R367TER_PLLSETUP,	0x18},
-	{R367TER_DUAL_AD12,	0x04},/* for xc5000; was 0x00 */
+	{R367TER_DUAL_AD12,	0x0C},/* for xc5000 AGC voltage 1.6V */
  	{R367TER_TSTBIST,	0x00},
  	{R367TER_PAD_COMP_CTRL,	0x00},
  	{R367TER_PAD_COMP_WR,	0x00},
@@ -599,7 +599,7 @@ static struct st_register 
def0367cab[STV0367CAB_NBREGS] = {
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

