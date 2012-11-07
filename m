Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab2KGP64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:58:56 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52147 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab2KGP6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 10:58:54 -0500
Message-ID: <1352303927.7614.3.camel@phoenix>
Subject: [PATCH 2/2] pinctrl: lantiq: Staticize ltq_pinctrl_dt_free_map
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: John Crispin <blogic@openwrt.org>, linux-kernel@vger.kernel.org
Date: Wed, 07 Nov 2012 23:58:47 +0800
In-Reply-To: <1352303879.7614.2.camel@phoenix>
References: <1352303879.7614.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not referenced outside of this file.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-lantiq.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-lantiq.c b/drivers/pinctrl/pinctrl-lantiq.c
index d670ad6..4eb6854 100644
--- a/drivers/pinctrl/pinctrl-lantiq.c
+++ b/drivers/pinctrl/pinctrl-lantiq.c
@@ -128,10 +128,10 @@ static int ltq_pinctrl_dt_subnode_size(struct device_node *np)
 	return ret;
 }
 
-int ltq_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
-				struct device_node *np_config,
-				struct pinctrl_map **map,
-				unsigned *num_maps)
+static int ltq_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
+				      struct device_node *np_config,
+				      struct pinctrl_map **map,
+				      unsigned *num_maps)
 {
 	struct pinctrl_map *tmp;
 	struct device_node *np;
-- 
1.7.9.5



