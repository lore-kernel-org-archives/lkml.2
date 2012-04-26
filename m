Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab2DZSqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:46:06 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:52353 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab2DZSqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:46:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAE+XmU9bdWOb/2dsb2JhbABFsXCBB4IKAQV5EFE8GweII7p4kGUElX2QQIJq
X-IronPort-AV: E=Sophos;i="4.75,487,1330902000"; 
   d="scan'208";a="981960568"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com,
        boyod.yang@siliconmotion.com.cn, wuzhangjin@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH RESEND 0/7] staging: sm7xx: code improvements and cleanup
Date: Thu, 26 Apr 2012 20:45:48 +0200
Message-Id: <1335465955-32057-1-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <20120425205532.GA9642@kroah.com>
References: <20120425205532.GA9642@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches implement some code improvements, dead code removal
and cleanup. New code uses dynamic debug support.

The patches address new checkpatch warnings.

Patches tested with SM712.

Javier M. Mellid (7):
  staging: sm7xx: remove old references and non updated comments
  staging: sm7xx: dead code removal
  staging: sm7xx: use dynamic debug support
  staging: sm7xx: use dynamic debug support to show info and errors
  staging: sm7xx: merge hardware information in smtcfb_info struct
  staging: sm7xx: remove driver version support
  staging: sm7xx: rename function

 drivers/staging/sm7xx/smtcfb.c |  232 +++++++++++++++-------------------------
 drivers/staging/sm7xx/smtcfb.h |    8 --
 2 files changed, 87 insertions(+), 153 deletions(-)

-- 
1.7.2.5

