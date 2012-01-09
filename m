Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab2AIIfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 03:35:32 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:51679 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2AIIfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 03:35:31 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-d4-4f0aa6d12e84
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: lrg@ti.com, sameo@linux.intel.com, linux-kernel@vger.kernel.org
References: <1325225153-32389-1-git-send-email-sbkim73@samsung.com>
 <20120109072515.GE22134@opensource.wolfsonmicro.com>
In-reply-to: <20120109072515.GE22134@opensource.wolfsonmicro.com>
Subject: RE: [PATCH v4] regulator: Add S5M8767A regulator driver
Date: Mon, 09 Jan 2012 17:35:47 +0900
Message-id: <01d901cccea9$af3b8490$0db28db0$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: AczOn+ORm44JxwADSrq21EyURZIbKwACLnIg
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Mon, Jan 9, 2011 at 04:25PM, Mark Brown wrote:

> I was expecting a new version with these:
> 
> > +static int s5m8767_reg_enable_suspend(struct regulator_dev *rdev)
> > +static int s5m8767_reg_disable_suspend(struct regulator_dev *rdev)
> 

After delete above functions, Is it right to code like below?

+static struct regulator_ops s5m8767_buck_ops = {
+	.enable	 = s5m8767_reg_enable,
+	.disable	 = s5m8767_reg_disable,
+	.set_suspend_enable	= s5m8767_reg_enable,
+	.set_suspend_disable	= s5m8767_reg_disable,

Thanks,
Sangbeom.

