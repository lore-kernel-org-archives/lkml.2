Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab0CXLMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 07:12:24 -0400
Received: from smtp.nokia.com ([192.100.105.134]:42768 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab0CXLMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 07:12:21 -0400
Subject: [GIT PULL] OMAP DSS fixes
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Wed, 24 Mar 2010 13:11:58 +0200
Message-ID: <1269429118.3032.74.camel@tubuntu.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Mar 2010 11:12:02.0339 (UTC) FILETIME=[D44A2730:01CACB42]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull three bug fixes for OMAP display subsystem:


The following changes since commit 57d54889cd00db2752994b389ba714138652e60c:
  Linus Torvalds (1):
        Linux 2.6.34-rc1

are available in the git repository at:

  git://gitorious.org/linux-omap-dss2/linux.git for-linus

Thomas Weber (1):
      OMAP: DSS2: VRAM: Fix early_param for vram

Tomi Valkeinen (2):
      OMAP: DSS2: initialize dss clk sources properly
      OMAP: DSS2: panel-generic: re-implement mode changing

 drivers/video/omap2/displays/panel-generic.c |   22 ++++++++++++++++++++++
 drivers/video/omap2/dss/dss.c                |    3 +++
 drivers/video/omap2/vram.c                   |   11 ++++++-----
 3 files changed, 31 insertions(+), 5 deletions(-)


