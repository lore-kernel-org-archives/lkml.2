Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389Ab2FGXEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 19:04:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58951 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758176Ab2FGXE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 19:04:27 -0400
From: Sam Hansen <solid.se7en@gmail.com>
To: Sam Hansen <sam@meebo-inc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        Sam Hansen <solid.se7en@gmail.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 0/3] Styleguide conformity
Date: Thu,  7 Jun 2012 16:03:46 -0700
Message-Id: <1339110229-19383-1-git-send-email-solid.se7en@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1339100404-18773-1-git-send-email-solid.se7en@gmail.com>
References: <1339100404-18773-1-git-send-email-solid.se7en@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Hansen <sam@meebo-inc.com>

This patch set addresses basic checkpatch.pl issues.

Sam Hansen (3):
  staging: zram: conventions pr_warning -> pr_warn()
  staging: zram: conventions, __aligned() attribute
  staging: zram: conventions, line splitting

 drivers/staging/zram/zram_drv.c |   16 ++++++++--------
 drivers/staging/zram/zram_drv.h |    2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

V2 - Moving arguments for pr_info() to the next line.
-- 
1.7.5.4

