Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333Ab2KWJEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:04:23 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:27180 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab2KWJEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:04:16 -0500
X-AuditID: cbfee61b-b7f616d00000319b-d2-50af3c0d1190
From: Byungho An <bh74.an@samsung.com>
To: davem@davemloft.net, peppe.cavallaro@st.com, jeffrey.t.kirsher@intel.com
Cc: netdev@vger.kernel.org, kgene.kim@samsung.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] net: stmmac: add SGMII RAL control bit
Date: Fri, 23 Nov 2012 18:04:12 +0900
Message-id: <004c01cdc959$81bc5c50$853514f0$%an@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3JWYGtO5Fb2yZeQlak1FauorDe+g==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zQ11em/UBBqe+iVhc3jWHzeLYAjEH
	Jo/Pm+QCGKO4bFJSczLLUov07RK4MhoXfWIsuMtXMaPrPksDYxdPFyMnh4SAicT113+YIWwx
	iQv31rN1MXJxCAksY5T4eeMXK0xRw9RVTBCJ6YwS+8/OZ4FwfjFKnH56BqyKTUBNonnmZTYQ
	W0TAR+LG8ncsIDazgL9E9+SjYHFhAWuJuR++gtksAqoS+25OYgSxeQVsJKZOn8cCYQtK/Jh8
	D6pXS2L9zuNMELa8xOY1b4FO5QC6SF3i0V9diFV6Ese/vGaGKBGR2PfiHSPEeAGJb5MPsUCU
	y0psOsAMcrKEQDe7xLVny1kgHpOUOLjiBssERrFZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4
	KT3XSK84Mbe4NC9dLzk/dxMjJGakdzCuarA4xCjAwajEw2tYti5AiDWxrLgy9xCjBAezkggv
	k9j6ACHelMTKqtSi/Pii0pzU4kOMPkCXT2SWEk3OB8ZzXkm8obGxiZmJqYm5pam5KQ5hJXHe
	Zo+UACGB9MSS1OzU1ILUIphxTBycUg2MGSzaC3eqfOtNFI64dXvOglD111MOqbgKVSjNCkmY
	nzHLW0LWKIjd+f03i1thj1WcOuQtxSV8uwzqDx77HiK1Mu2mY+79v046XnFPj+bXXo2M3brY
	IuVcfqJ34x3V3OfbfN8Yzbh1deHbmiXONd553H7uH6auEhDhSf6rkbrqlZtrU1PH4g1KLMUZ
	iYZazEXFiQAAuJDqxgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t9jQV1em/UBBts6BS0u75rDZnFsgZgD
	k8fnTXIBjFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6
	bpk5QJOVFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBmNiz4xFtzlq5jR
	dZ+lgbGLp4uRk0NCwESiYeoqJghbTOLCvfVsXYxcHEIC0xkl9p+dzwLh/GKUOP30DCtIFZuA
	mkTzzMtsILaIgI/EjeXvWEBsZgF/ie7JR8HiwgLWEnM/fAWzWQRUJfbdnMQIYvMK2EhMnT6P
	BcIWlPgx+R5Ur5bE+p3HmSBseYnNa94ydzFyAF2kLvHory7EKj2J419eM0OUiEjse/GOcQKj
	wCwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiOyGfSOxhXNVgc
	YhTgYFTi4TUsWxcgxJpYVlyZe4hRgoNZSYSXSWx9gBBvSmJlVWpRfnxRaU5q8SFGH6BHJzJL
	iSbnA5NFXkm8obGJmZGlkZmFkYm5OQ5hJXHeZo+UACGB9MSS1OzU1ILUIphxTBycUg2MKU/f
	7SjwXnJSfXNKYB1Dl8pm9z9zb8wO2a8tEGpTlpg/Ud/31Y8HTL/fPtnXftfHYVL8hKrpa3x5
	tp+XtZVMuDDvN9Pyjw6BivWz7xw5IbhB1ONgeQ3nptJbWZ6L3xyTOXtKxt3Tvkrrqd37szEB
	+6e/FTiypXdlqdyaVN2ZNSJTPE3+6WlpK7EUZyQaajEXFScCAKU5UzD1AgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch sets SGMRAL bit in AN control register.
This bit forces the SGMII RAL block to operate in the
speed configured in the Speed and Port Select bits of
the GMAC Configuration register.

Signed-off-by: Byungho An <bh74.an@samsung.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig       |    7 +++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   11 +++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig
b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 9f44827..d65d63b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -54,6 +54,13 @@ config STMMAC_DA
 	  By default, the DMA arbitration scheme is based on Round-robin
 	  (rx:tx priority is 1:1).
 
+config STMMAC_SGMRAL
+	bool "STMMAC SGMII RAL Control"
+	default n
+	---help---
+	  SGMII RAL block to operate in the speed configured in the speed
+	  and port select bits of the MAC Configuration register.
+
 config STMMAC_TIMER
 	bool "STMMAC Timer optimisation"
 	default n
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a719c87..670e585 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1096,6 +1096,17 @@ static int stmmac_open(struct net_device *dev)
 		/* GMAC_CONTROL_PS : Port Selection for GMII */
 		value &= ~(0x8000);
 		writel(value, priv->ioaddr);
+
+#ifdef CONFIG_STMMAC_SGMRAL
+		value = readl(priv->ioaddr + 0xc0);
+		/*
+		 * forces RAL block to operate in speed configured
+		 * in the speed and port select bits of GMAC
+		 * configuration register
+		 */
+		value = |= 0x40000;
+		writel(value, priv->ioaddr + 0xc0);
+#endif
 	}
 
 	/* Request the IRQ lines */
-- 
1.7.9.5

