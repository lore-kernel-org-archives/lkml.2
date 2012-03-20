Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab2CTWBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 18:01:14 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:47756 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758442Ab2CTWBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 18:01:11 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: lrg@ti.com, broonie@opensource.wolfsonmicro.com
Subject: [RFC] REGULATOR: core add 3 new modes/statuses
Date: Tue, 20 Mar 2012 21:50:57 +0000
Message-Id: <1332280258-5044-1-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, wanted to check how well a patch of this sort would go down before
sending a final version.

At least two of the PMICs I support twl6032 and twl6035 (and varients)
would benefit from these extra modes.

Graeme

