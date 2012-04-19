Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab2DSJAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 05:00:14 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16323 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab2DSJAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 05:00:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 19 Apr 2012 02:00:10 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: jic23@cam.ac.uk, gregkh@linuxfoundation.org, max@stro.at,
        jbrenner@taosinc.com, bfreed@chromium.org, lars@metafoo.de,
        grundler@chromium.org
Cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 0/2] staging: iio: light: use regmap in isl29018 for register access
Date: Thu, 19 Apr 2012 14:29:33 +0530
Message-Id: <1334825975-7062-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is patch series for using regmap framework for accessing device register.
THe first patch is for using tab for ndenting and second patch is for
using regmap apis for register accesses.

Laxman Dewangan (2):
  staging: iio: light: convert multiple spaces to tab
  staging: iio: light: isl29018: use regmap for register access

 drivers/staging/iio/light/Kconfig    |   19 ++--
 drivers/staging/iio/light/isl29018.c |  176 +++++++++++++++++-----------------
 2 files changed, 99 insertions(+), 96 deletions(-)

