Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab0LTUIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 15:08:42 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58156 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104Ab0LTUIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 15:08:41 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67599772"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/3] hvc_dcc cleanups and fixes
Date: Mon, 20 Dec 2010 12:08:35 -0800
Message-Id: <1292875718-7980-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.4.516.g15368e
In-Reply-To: <1292649385-28771-1-git-send-email-sboyd@codeaurora.org>
References: <1292649385-28771-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the split patches.

The first two patches cleanup and fix the hvc_dcc driver for my
compiler. The final patch is more controversial, it removes the
v6 and v7 differences in this driver.

Stephen Boyd (3):
  hvc_dcc: Fix bad code generation by marking assembly volatile
  hvc_dcc: Simplify put_chars()/get_chars() loops
  hvc_dcc: Simplify assembly for v6 and v7 ARM

 drivers/char/hvc_dcc.c |   43 +++++++------------------------------------
 1 files changed, 7 insertions(+), 36 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

