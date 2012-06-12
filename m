Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab2FLNXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 09:23:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab2FLNXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 09:23:40 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC 0/5] EDAC log cleanups
Date: Tue, 12 Jun 2012 10:23:26 -0300
Message-Id: <cover.1339507094.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do some cleanups at the error logs:
	- amd64_edac: don't print driver's name at the error strings;
	- arch parameter is never used. Remove it from edac_mc_handle_error();
	- Add error count parameter to edac_mc_handle_error();
	- Use the error count parameter on sb_edac/i7core_edac.

Mauro Carvalho Chehab (5):
  amd64_edac: Don't pass driver name as an error parameter
  edac: remove arch-specific parameter for the error handler
  edac: allow to specify how many errors were received
  i7core_edac: properly handle error count
  sb_edac: properly handle error count

 drivers/edac/amd64_edac.c      |   53 +++++++++++++++++-----------------------
 drivers/edac/amd76x_edac.c     |    8 +++---
 drivers/edac/cell_edac.c       |    8 +++---
 drivers/edac/cpc925_edac.c     |    8 +++---
 drivers/edac/e752x_edac.c      |   16 ++++++------
 drivers/edac/e7xxx_edac.c      |   16 ++++++------
 drivers/edac/edac_core.h       |    4 +--
 drivers/edac/edac_mc.c         |   32 ++++++++++++------------
 drivers/edac/edac_mc_sysfs.c   |    4 +--
 drivers/edac/i3000_edac.c      |   12 ++++-----
 drivers/edac/i3200_edac.c      |   12 ++++-----
 drivers/edac/i5000_edac.c      |   16 ++++++------
 drivers/edac/i5100_edac.c      |    8 +++---
 drivers/edac/i5400_edac.c      |    8 +++---
 drivers/edac/i7300_edac.c      |    8 +++---
 drivers/edac/i7core_edac.c     |   33 +++++++++----------------
 drivers/edac/i82443bxgx_edac.c |    8 +++---
 drivers/edac/i82860_edac.c     |   12 ++++-----
 drivers/edac/i82875p_edac.c    |   12 ++++-----
 drivers/edac/i82975x_edac.c    |   12 ++++-----
 drivers/edac/mpc85xx_edac.c    |    8 +++---
 drivers/edac/mv64x60_edac.c    |    8 +++---
 drivers/edac/pasemi_edac.c     |    8 +++---
 drivers/edac/ppc4xx_edac.c     |    8 +++---
 drivers/edac/r82600_edac.c     |    8 +++---
 drivers/edac/sb_edac.c         |   11 ++++-----
 drivers/edac/tile_edac.c       |    4 +--
 drivers/edac/x38_edac.c        |   12 ++++-----
 28 files changed, 171 insertions(+), 186 deletions(-)

-- 
1.7.10.2

