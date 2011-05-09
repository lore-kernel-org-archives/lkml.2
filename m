Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab1EIPX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 11:23:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37195 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752084Ab1EIPX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 11:23:26 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 0/2] Further small GMA500 fixes
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Mon, 09 May 2011 16:04:12 +0100
Message-ID: <20110509150334.28865.25665.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alan Cox (2):
      gma500: Fix dumb create crash
      gma500: sort out the file operations


 drivers/staging/gma500/psb_drv.c |   50 +++++---------------------------------
 drivers/staging/gma500/psb_gem.c |    6 ++---
 drivers/staging/gma500/psb_gtt.c |    2 +-
 3 files changed, 10 insertions(+), 48 deletions(-)

