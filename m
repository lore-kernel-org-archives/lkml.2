Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab1JTVw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:52:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab1JTVwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:52:55 -0400
Date: Thu, 20 Oct 2011 19:52:36 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] Add an experimental EDAC driver for Sandy Bridge
Message-ID: <20111020195236.513dd138@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add an experimental driver for Sandy Bridge machines.
Minimum CPU step required for it to work is step-C0.

This driver is experimental, and might be blaming the wrong memory DIMM,
so use it with care. Reports are welcomed.

Mark A. Grondona (1):
  EDAC: Fix incorrect edac mode reporting in sb_edac

Mauro Carvalho Chehab (3):
  edac: Add an experimental new driver to support Sandy Bridge CPU's
  edac: sb_edac: Add it to the building system
  edac: tag sb_edac as EXPERIMENTAL, as it requires more testing

 drivers/edac/Kconfig   |   15 +
 drivers/edac/Makefile  |    1 +
 drivers/edac/sb_edac.c | 1893 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1909 insertions(+), 0 deletions(-)
 create mode 100644 drivers/edac/sb_edac.c

-- 
1.7.6.4

