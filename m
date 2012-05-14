Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab2ENCGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 22:06:20 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:59187 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000Ab2ENCGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 22:06:16 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        b-cousson@ti.com, linux-omap@vger.kernel.org
Subject: [PATCH 0/4] Adding support for Palmas PMIC
Date: Mon, 14 May 2012 10:58:28 +0900
Message-Id: <1336960712-2812-1-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the MFD and regulator parts for the Palmas family of chips from
Texas Instruments.

It has been decided to use the Palmas name in the driver instead of
the various marketing names the family will be avilable with to avoid
confusion. The driver will in the future determine the exact product
from the OTP information and adapt accordingly.

Currently the driver will handle the twl6035 and twl6037 varients.

Graeme

