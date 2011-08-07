Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab1HGHC4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 03:02:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57984 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab1HGHCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 03:02:54 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: [PATCH 0/2] ptp: bug fixes for 3.1 and 3.0
Date: Sun,  7 Aug 2011 09:03:02 +0200
Message-Id: <cover.1312699693.git.richard.cochran@omicron.at>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches fix two bugs in the PTP Hardware Clock drivers. The
drivers were first introduced in Linux version 3.0.

Please apply them.

Thanks,
Richard


Richard Cochran (2):
  gianfar: fix fiper alignment after resetting the time
  dp83640: increase receive time stamp buffer size

 drivers/net/gianfar_ptp.c |    9 ++-------
 drivers/net/phy/dp83640.c |    5 ++---
 2 files changed, 4 insertions(+), 10 deletions(-)

