Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab2LQCDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 21:03:40 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:10673 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab2LQCDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 21:03:38 -0500
X-AuditID: cbfee61b-b7f616d00000319b-e6-50ce7d794275
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
References: 
In-reply-to: 
Subject: [PATCH 2/2] pinctrl: exynos5440: Fix compile error in
 pinctrl-exynos5440/samsung.c
Date: Mon, 17 Dec 2012 11:03:37 +0900
Message-id: <001c01cddbfa$b9f858e0$2de90aa0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3UU7Eg1il1ze7QRMSoT4lj3ZIiNgCUy8QQAVS0fuAAAD0AgA==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zI93K2nMBBst3S1lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MvsnvmQsa2SrenWtnbGDsYe1i5OSQEDCROHDnOyOELSZx4d56
	ti5GLg4hgWWMEv0P+tlgik70zmWGSCxilJi0ficLhDOPSeLt3xlgo9gEdCWOrd8CZosIeEuc
	mvKLGcRmFmhjlNi8IriLkQOogVtidXMQSJhTgEdi3Z9OsBJhgViJM12XmEBsFgFViTm7z4Nd
	xCtgJ9G+9TmULSjxY/I9FoiRWhLrdx5ngrDlJTavecsMMl5CQF3i0V9diAucJKZtncAKUSIi
	se/FO0aI8QIS3yYfYoEol5XYdADsLQmBeewSF5a/YYL4V1Li4IobLBMYJWYh2TwLyeZZSDbP
	QrJiASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYyQyJLewbiqweIQowAHoxIPr2HquQAh
	1sSy4srcQ4wSHMxKIrz87kAh3pTEyqrUovz4otKc1OJDjD5Al09klhJNzgdGfV5JvKGxsYmZ
	iamJuaWpuSkOYSVx3maPlAAhgfTEktTs1NSC1CKYcUwcnFINjNtm/xTTvMujdT/nEd+1KfOf
	+a6Lko7I6Pj+u32p/aVFG44taohZnROzneed0Rv2yh2zUp8e42eeb7I3ktVzy4mQ6i69JduX
	TZttfXbhtrvGgRfihbIcupbqd+VMWFEybwf/osl3kmKcF4Q+rTu4u2rNXK+O735qMpP/OZ3Y
	emFFF2tXeOur05uUWIozEg21mIuKEwFr+6fC2QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jAd3K2nMBBrvfi1lc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjL7J75kLGtkq3p1rZ2xg
	7GHtYuTkkBAwkTjRO5cZwhaTuHBvPVsXIxeHkMAiRolJ63eyQDjzmCTe/p0B1sEmoCtxbP0W
	MFtEwFvi1JRfYN3MAm2MEptXBHcxcgA1cEusbg4CCXMK8Eis+9MJViIsECtxpusSE4jNIqAq
	MWf3eUYQm1fATqJ963MoW1Dix+R7LBAjtSTW7zzOBGHLS2xe85YZZLyEgLrEo7+6EBc4SUzb
	OoEVokREYt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+
	7iZGcNw+k97BuKrB4hCjAAejEg+vYeq5ACHWxLLiytxDjBIczEoivPzuQCHelMTKqtSi/Pii
	0pzU4kOMPkCPTmSWEk3OB6aUvJJ4Q2MTMyNLIzMLIxNzcxzCSuK8zR4pAUIC6YklqdmpqQWp
	RTDjmDg4pRoYDSb2TvYT5bYWP3bGnevn5qU5jKf6d3r8uZ3AKSq6YqXMox3vGcUvPrWw8e1o
	clom8cJEcSWb4MK/U196qgZ+v/3FWl24ZvNmnUKTn0enH7u7/snEIIb7Sftvqecsu/Tx0exK
	2TuBHrX/Vmxpt+65O4uxaCJDwIT1O54sXzIpaKeIo+T2qNz4t0osxRmJhlrMRcWJACJ5TdsI	AwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

error: drivers/pinctrl/pinctrl-exynos5440.o: multiple definition of 'pcfgs'
drivers/pinctrl/pinctrl-samsung.o: previous definition here

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/pinctrl/pinctrl-exynos5440.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-exynos5440.c
b/drivers/pinctrl/pinctrl-exynos5440.c
index b8635f6..8a863a3 100644
--- a/drivers/pinctrl/pinctrl-exynos5440.c
+++ b/drivers/pinctrl/pinctrl-exynos5440.c
@@ -117,7 +117,7 @@ struct exynos5440_pinctrl_priv_data {
 };
 
 /* list of all possible config options supported */
-struct pin_config {
+static const struct pin_config {
 	char		*prop_cfg;
 	unsigned int	cfg_type;
 } pcfgs[] = {
-- 
1.7.4.1

