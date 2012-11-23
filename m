Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964906Ab2KWHfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:35:04 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:47995 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964780Ab2KWHfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:35:01 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-cb-50af27236e0d
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, broonie@opensource.wolfsonmicro.com,
        myungjoo.ham@samsung.com, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, t.figa@samsung.com
Subject: [PATCH 0/3] regulator: max8997: minor updates and device tree support
Date: Fri, 23 Nov 2012 13:33:12 +0530
Message-id: <1353657795-1725-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAJMWRmVeSWpSXmKPExsVy+t9jQV1l9fUBBnOeGlpc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVs73/MVnCDreLDj6vsDYw/WboYOTkkBEwk+iefY4Sw
	xSQu3FvP1sXIxSEkMJ1RYsrBQ4wQThuTxNG2XlaQKjYBA4lHC9+xg9giAgoSm3ufsYIUMQvs
	YJS40DKDCSQhLOAnceb8HbCxLAKqEnPX/ABbxyvgIbH2QzfUOiWJDb1HmSYwci9gZFjFKJpa
	kFxQnJSea6hXnJhbXJqXrpecn7uJEezPZ1I7GFc2WBxiFOBgVOLhNSxbFyDEmlhWXJl7iFGC
	g1lJhJdJbH2AEG9KYmVValF+fFFpTmrxIUZpDhYlcd5mj5QAIYH0xJLU7NTUgtQimCwTB6dU
	AyN33LT7O5iO67/l3m7NPq/ly1rB503W820fZt77vUhzmqD8z7l6lyYU6S9Q2ie6NtK+TTK/
	xEPe/VM585+HPRe/BzRPcTvZmV+a9E6HoyM0Y7IOi+06bbF1fFcezE38o7ksz0UptVdURGk5
	T+Tx4mNzyoSlHGs5t8l9Y9HRYBE65FjJeibJSomlOCPRUIu5qDgRABbui1jjAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series includes two minor updates to the gpio dvs code in max8997
regulator driver and adds device tree support for the same driver.

Thomas Abraham (3):
  regulator: max8997: reorder buck1/2/5 dvs setup code
  regulator: max8997: limit the number of dvs registers programmed in non-dvs mode
  regulator: add device tree support for max8997

 .../bindings/regulator/max8997-regulator.txt       |  146 ++++++++++++++++
 drivers/mfd/max8997.c                              |   73 ++++++++-
 drivers/regulator/max8997.c                        |  181 ++++++++++++++++++--
 include/linux/mfd/max8997-private.h                |    1 +
 include/linux/mfd/max8997.h                        |    1 +
 5 files changed, 384 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/max8997-regulator.txt

