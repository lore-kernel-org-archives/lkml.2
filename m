Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab0KSHn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 02:43:27 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39663 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab0KSHn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 02:43:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=n41YX9F4YJF7iPZ1Hsb7DF1IpmZZcL3T5bnErhDa1G0zsUSqH4KTRovJD8Hvzm/kdI
         pIBNX7poAzEaQ0E/0HV0VBuksUaM3XOjl1Pa5/1wYQjW84T1t3FeBbezBiXa0pmF6d5g
         oMp9wQgadkwqIlHb68xul9KxcsbQHTGk+peFE=
Subject: [PATCH] ASoC: uda134x - set reg_cache_default to uda134x_reg
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Christian Pellegrin <chripell@evolware.org>
Content-Type: text/plain
Date: Fri, 19 Nov 2010 15:48:06 +0800
Message-Id: <1290152886.10001.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After checking the code in 2.6.36,
I found this is missing during multi-component conversion.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/uda134x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/uda134x.c b/sound/soc/codecs/uda134x.c
index 8ea81d4..6b6c0d2 100644
--- a/sound/soc/codecs/uda134x.c
+++ b/sound/soc/codecs/uda134x.c
@@ -597,6 +597,7 @@ static struct snd_soc_codec_driver soc_codec_dev_uda134x = {
 	.resume =       uda134x_soc_resume,
 	.reg_cache_size = sizeof(uda134x_reg),
 	.reg_word_size = sizeof(u8),
+	.reg_cache_default = uda134x_reg,
 	.reg_cache_step = 1,
 	.read = uda134x_read_reg_cache,
 	.write = uda134x_write,
-- 
1.7.2



