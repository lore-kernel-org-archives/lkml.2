Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab2GQDIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 23:08:25 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52381 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753772Ab2GQDIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 23:08:23 -0400
X-Sasl-enc: /wKEOEFwD6mTqQps1roKemQw3cpIrzzZSwVYwcAxonss 1342494502
From: Erik Jones <erik@ejnode.com>
To: gregkh@linuxfoundation.org
Cc: edwin_rong@realsil.com.cn, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: staging: rts5139: rts51x_card: coding style fix 
Date: Mon, 16 Jul 2012 22:52:32 -0400
Message-Id: <1342493554-16554-1-git-send-email-erik@ejnode.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set fixes coding style issues in rts51x_card driver.
Issues were found with scripts/checkpatch.pl tool.
