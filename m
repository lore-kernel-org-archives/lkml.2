Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab2KTJWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:22:30 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44536 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab2KTJW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:22:28 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC/PATCH 0/3] CLK: add more devm_* APIs
Date: Tue, 20 Nov 2012 01:22:16 -0800
Message-Id: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When looking at recent driver conversions to managed resources (devm_*) there
is no devm_clk_prepare() and similar functions, which forces mixing of 2
resource management styles (managed/classic) in the same driver, which is not
great.

This patch series adds more devm_* managed APIs to the CLK subsystem so that
driver conversions can be "pure".

Not tested as I do not have relevant hardware, so testing is appreciated.

Thanks!

-- 
Dmitry
