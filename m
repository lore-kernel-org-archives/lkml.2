Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab1G0KdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 06:33:09 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:50208 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab1G0KdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 06:33:07 -0400
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] regulator: tps65023: TPS65020 support and bug fixes 
Date: Wed, 27 Jul 2011 12:32:44 +0200
Message-Id: <1311762767-20263-1-git-send-email-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <marcus.folkesson@gmail.com>
References: <marcus.folkesson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a set of patches that fixes bugs in the tps65023 driver and gives support for the similiar tps65020 regulator.
The patches is applied on kernel version 3.0.
The tps65020 support is tested on a PXA270-based custom board but with an older kernel version
without the regmap implementation.

Bug fixes:
* The original driver does not allows voltage adjustments by i2c
* The original driver map wrong regulator as core-regulator in the tps65021 support

Changes:
* A new struct containing voltage-tables, core-regulator and size of voltage tables is passed by as driver data.

New support:
* Added support for the tps65020 regulator.

Feedback is very much appreciated

