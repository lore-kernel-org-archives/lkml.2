Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab2EaP6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:58:43 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:39155 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625Ab2EaP6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:58:42 -0400
Message-Id: <201205311557.q4VFvRAl010948@sw-eng-lt-dc-vm2>
From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Date: Thu, 31 May 2012 17:46:37 +0200
Subject: [PATCH 0/4] regmap: Add support for indirect addressing/paging into regmap.
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Anthony Olech <Anthony.Olech@diasemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patches bring the new feature for register mapping. Changes are
split into two patches to make it more readible.

Krystian Garbaciak (4):
  regmap: Reorganise internal read/write functions.
  regmap: Make internal read/write functions reentrant from themselves.
  regmap: Add support for register indirect addressing.
  regmap: Minor optimisation for _regmap_raw_write().

 drivers/base/regmap/internal.h |   17 +++
 drivers/base/regmap/regmap.c   |  266 +++++++++++++++++++++++++++++++++-------
 include/linux/regmap.h         |   37 ++++++
 3 files changed, 276 insertions(+), 44 deletions(-)

