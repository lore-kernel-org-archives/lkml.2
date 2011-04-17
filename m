Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab1DQAyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 20:54:17 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:65279 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab1DQAyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 20:54:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JZQ4K0daRuh1zJUSMQAGmDim/+3q8nqENjl0PElLR87bD6iyCL15V5XFA7lks06hRT
         48CdQX91IIElkqUdSVqQoJLajIM7xYJn+bbJmNLeikR78EaDM/9pXoN8j8Y6AAvC3rvc
         7AQc8TzP0i71ci5SUVujkQPTyTIqrj5dgIAs8=
Message-ID: <4DAA3A25.30501@gmail.com>
Date: Sun, 17 Apr 2011 08:53:57 +0800
From: Wanlong Gao <wanlong.gao@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org, lrg@slimlogic.co.uk
Subject: [PATCH] drivers:regulator:change debug statement be consistent with
 the style of the rest.
References: <1302968543-3150-1-git-send-email-wanlong.gao@gmail.com> <20110416175440.GD25811@opensource.wolfsonmicro.com>
In-Reply-To: <20110416175440.GD25811@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



change the "mc13783_regulator_probe" string in the function 
"mc13783_regulator_probe"
to "__func__" for the debug statement be consistent with the style of 
the rest of
the file.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

---
  drivers/regulator/mc13783-regulator.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c 
b/drivers/regulator/mc13783-regulator.c
index 23249cb..b8a00c7 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -341,7 +341,7 @@ static int __devinit mc13783_regulator_probe(struct 
platform_device *pdev)
         struct mc13783_regulator_init_data *init_data;
         int i, ret;

-       dev_dbg(&pdev->dev, "mc13783_regulator_probe id %d\n", pdev->id);
+       dev_dbg(&pdev->dev, "%s id %d\n", __func__, pdev->id);

         priv = kzalloc(sizeof(*priv) +
                         pdata->num_regulators * 
sizeof(priv->regulators[0]),
-- 
1.7.3
