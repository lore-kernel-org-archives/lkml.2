Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab2DTH2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 03:28:22 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9460 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab2DTH2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 03:28:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 20 Apr 2012 00:28:20 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: jic23@cam.ac.uk, gregkh@linuxfoundation.org, max@stro.at,
        jbrenner@taosinc.com, bfreed@chromium.org, lars@metafoo.de,
        grundler@chromium.org
Cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V4 0/2] staging: iio: light: use regmap in isl29018 for register access
Date: Fri, 20 Apr 2012 12:57:36 +0530
Message-Id: <1334906858-25578-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is patch series for using regmap framework for accessing device register.
THe first patch is for using tab for ndenting and second patch is for 
using regmap apis for register accesses.

Changes from V2: 
 Taken care of Lars's review comment.

Changes from V3:
Taken care of Lars's and Grant's comment about COMMAND1 register access.
-Use regmap_write() for ADD_COMMAND1 and keeping this as volatile.


Laxman Dewangan (2):
  staging: iio: light: convert multiple spaces to tab
  staging: iio: light: isl29018: use regmap for register access

 drivers/staging/iio/light/Kconfig    |   19 ++--
 drivers/staging/iio/light/isl29018.c |  178 +++++++++++++++++-----------------
 2 files changed, 100 insertions(+), 97 deletions(-)

