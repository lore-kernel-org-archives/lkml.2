Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab2LQCCs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 21:02:48 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:53902 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab2LQCCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 21:02:47 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-b4-50ce7d450e05
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
References: 
In-reply-to: 
Subject: [PATCH 1/2] pinctrl: samsung: Fix compile error in
 pinctrl-exynos5440/samsung.c
Date: Mon, 17 Dec 2012 11:02:45 +0900
Message-id: <001b01cddbfa$9b306740$d19135c0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3UU7Eg1il1ze7QRMSoT4lj3ZIiNgCUy8QQAVS0fuA=
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zQ13X2nMBBs8m6Flc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MRzPPsxR8Ya1ob3nC2sD4n6WLkZ1DQsBEYq9DFyMnkCUmceHe
	erYuRi4OIYFljBLfri9hgUiYSEydcwIqsYhRouvaNiYIZx6TxKrmR2wgVWwCuhLH1m9hBbFF
	BBQkNvc+A7OZBdoYJTavCO5i5ABq4JZY3RwEEuYU4JFY96eTGcQWFoiSmPdqBxOIzSKgKjHx
	1lVGEJtXwE7i78I9bBC2oMSPyfdYIEZqSazfeZwJwpaX2LzmLTPIeAkBdYlHf3UhLrCSuPj0
	MCNEiYjEvhfvGCHGC0h8m3yIBaJcVmLTAWaQTyQEFrFLfNvczArxr6TEwRU3WCYwSsxCsnkW
	ks2zkGyehWTFAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxghUSW1g3Flg8UhRgEORiUe
	XqPUcwFCrIllxZW5hxglOJiVRHj53YFCvCmJlVWpRfnxRaU5qcWHGH2ALp/ILCWanA+M+LyS
	eENjYxMzE1MTc0tTc1McwkrivM0eKQFCAumJJanZqakFqUUw45g4OKUaGE/xGT/c+NPowosW
	y7CJeue5T0btnjNz8d731yuLStZPX7/qgu7XtyIfGKy794v8nPTtspH6r+8Hju8sZ0jrqaxY
	/X5rc9+XhlcODhtLlGuniAT8ihA0eLgpa5bBjI3vY57nFYVGBp1u6mvV2DT9vOWj9YsP6Stv
	6s8Nt6hwSjg0+xMzb9epI/5KLMUZiYZazEXFiQBDD4a21wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jAV3X2nMBBi+ualpc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjEczz7MUfGGtaG95wtrA
	+J+li5GTQ0LARGLqnBNsELaYxIV764FsLg4hgUWMEl3XtjFBOPOYJFY1PwKrYhPQlTi2fgsr
	iC0ioCCxufcZmM0s0MYosXlFcBcjB1ADt8Tq5iCQMKcAj8S6P53MILawQJTEvFc7mEBsFgFV
	iYm3rjKC2LwCdhJ/F+5hg7AFJX5MvscCMVJLYv3O40wQtrzE5jVvmUHGSwioSzz6qwtxgZXE
	xaeHGSFKRCT2vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl
	5+duYgTH7TOpHYwrGywOMQpwMCrx8BqlngsQYk0sK67MPcQowcGsJMLL7w4U4k1JrKxKLcqP
	LyrNSS0+xOgD9OhEZinR5HxgSskriTc0NjEzsjQyszAyMTfHIawkztvskRIgJJCeWJKanZpa
	kFoEM46Jg1OqgVGyY8m5l4efFu++eDuQccW8o8x2y5YxSBnN7HoSqb5I+aOZV359t9n2k2dy
	kprq9j6+mWvn+DDqgNcE2cUr4/tlQueIpzBLeRy6dfhtekjui7JQtVOar79823tg97PtU2/y
	P5dlet0n6nOe+XhxKntQcQ3PheuVDfNyTTxj1OSc9ZiPmH+T61RiKc5INNRiLipOBAB+dgbG
	CAMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

error: drivers/pinctrl/pinctrl-exynos5440.o: multiple definition of 'pcfgs'
drivers/pinctrl/pinctrl-samsung.o: previous definition here

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/pinctrl/pinctrl-samsung.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-samsung.c
b/drivers/pinctrl/pinctrl-samsung.c
index 8f31b65..fc98b38 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -37,7 +37,7 @@
 #define FSUFFIX_LEN		sizeof(FUNCTION_SUFFIX)
 
 /* list of all possible config options supported */
-struct pin_config {
+static const struct pin_config {
 	char		*prop_cfg;
 	unsigned int	cfg_type;
 } pcfgs[] = {
-- 
1.7.4.1

