Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab2GQDzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 23:55:07 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54729 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753509Ab2GQDzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 23:55:04 -0400
X-Sasl-enc: 4BlaKn7xjpRnl4QbGb4rLmUHbYW+FhMY2VxzJJbGwIG8 1342497302
From: Erik Jones <erik@ejnode.com>
To: gregkh@linuxfoundation.org
Cc: edwin_rong@realsil.com.cn, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 0] staging: rts5139: rts51x_card: coding style fix
Date: Mon, 16 Jul 2012 23:51:13 -0400
Message-Id: <1342497075-18517-1-git-send-email-erik@ejnode.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am resending this patch-set because the initial version's
subject didn't include [PATCH 0].

This patch-set fixes coding style issues in rts51x_card driver.
Issues were found with scripts/checkpatch.pl tool.
