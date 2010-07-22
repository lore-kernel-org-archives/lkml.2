Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab0GVWJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 18:09:19 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2527 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab0GVWJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 18:09:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6051"; a="48209969"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org
Subject: Possible memory leaks on driver core error paths
Date: Thu, 22 Jul 2010 15:09:00 -0700
Message-Id: <1279836546-26913-1-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In trying to understand the LDM, I came across a few places where
I believe it's possible to leak memory. The first patch appears to
just be a copy-paste bug, and 2-6 are all fixing the same fundamental
problem, an explanation of which is given in 2/6.

