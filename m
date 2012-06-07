Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab2FGUUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:20:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36508 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab2FGUU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:20:28 -0400
From: Sam Hansen <solid.se7en@gmail.com>
To: Sam Hansen <sam@meebo-inc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        Sam Hansen <solid.se7en@gmail.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Styleguide conformity
Date: Thu,  7 Jun 2012 13:20:01 -0700
Message-Id: <1339100404-18773-1-git-send-email-solid.se7en@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Hansen <sam@meebo-inc.com>

This patch set addresses basic checkpatch.pl issues.

Sam Hansen (3):
  staging: zram: conventions pr_warning -> pr_warn()
  staging: zram: conventions, __aligned() attribute
  staging: zram: conventions, line splitting

 drivers/staging/zram/zram_drv.c |   14 ++++++--------
 drivers/staging/zram/zram_drv.h |    2 +-
 2 files changed, 7 insertions(+), 9 deletions(-)

-- 
1.7.5.4

