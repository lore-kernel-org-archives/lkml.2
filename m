Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab1JWKvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 06:51:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46477 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab1JWKvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 06:51:52 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-96-4ea3f1c7a2cc
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
References: <009301cc915a$cd72d1c0$68587540$@com>
 <20111023084233.GB3135@opensource.wolfsonmicro.com>
In-reply-to: <20111023084233.GB3135@opensource.wolfsonmicro.com>
Subject: RE: [PATCH 2/3] mfd: Add s5m series irq support
Date: Sun, 23 Oct 2011 19:51:50 +0900
Message-id: <009801cc9171$c4ea1970$4ebe4c50$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcyRX7h8T91U7OnxRASmgkxW0UQrjQAEFzQA
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 05:43 PM , Mark Brown wrote:
 
> Actually, one of the things I want to do in the 3.3 timeframe is to
> factor out this code from my drivers into a regmap based irq_chip since
> it seems a lot of people are "drawing inspiration" from it.  This
> shouldn't be any form of blocker for merging this driver though.

I hope that this driver will be base code for regmap based irq driver
I want discuss more detail in Prague.
Thanks,

Sangbeom.

