Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab1ARGfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 01:35:55 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:18737 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab1ARGfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 01:35:54 -0500
From: Hong Xu <hong.xu@atmel.com>
To: linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, jamie@jamieiles.com, jacmet@sunsite.dk,
        ryan@bluewatersys.com
Cc: nicolas.ferre@atmel.com, hong.xu@atmel.com
Subject: [PATCH v4] MTD: atmel_nand: Add DMA support to access Nandflash 
Date: Tue, 18 Jan 2011 14:36:04 +0800
Message-Id: <1295332565-25610-1-git-send-email-hong.xu@atmel.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <hong.xu@atmel.com>
References: <hong.xu@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This v4 patch includes the fix according to the comments from
Ryan Mallon, Jamie Iles and Peter Korsgaard.

Thanks.

BR,
Hong
