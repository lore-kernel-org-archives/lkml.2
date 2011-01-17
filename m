Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab1AQHUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 02:20:24 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:7250 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab1AQHUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 02:20:23 -0500
From: Hong Xu <hong.xu@atmel.com>
To: linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, jamie@jamieiles.com, jacmet@sunsite.dk
Cc: nicolas.ferre@atmel.com, hong.xu@atmel.com
Subject: [PATCH v2] MTD: atmel_nand: Add DMA support to access Nandflash 
Date: Mon, 17 Jan 2011 15:20:08 +0800
Message-Id: <1295248809-30334-1-git-send-email-hong.xu@atmel.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <hong.xu@atmel.com>
References: <hong.xu@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes the fixes according to Jamie Iles and Peter Korsgaard
