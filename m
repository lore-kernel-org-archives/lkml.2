Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab1BCXsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 18:48:40 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29863 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab1BCXsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 18:48:38 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6245"; a="73123025"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv2 0/3] hvc_dcc cleanups and fixes
Date: Thu,  3 Feb 2011 15:48:33 -0800
Message-Id: <1296776916-21018-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <20110203221742.GA4159@kroah.com>
References: <20110203221742.GA4159@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Redone against tty-next and collected acks from Nicolas and Tony.

Stephen Boyd (3):
  hvc_dcc: Fix bad code generation by marking assembly volatile
  hvc_dcc: Simplify put_chars()/get_chars() loops
  hvc_dcc: Simplify assembly for v6 and v7 ARM

 drivers/tty/hvc/hvc_dcc.c |   43 +++++++------------------------------------
 1 files changed, 7 insertions(+), 36 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

