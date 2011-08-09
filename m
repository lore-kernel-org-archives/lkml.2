Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab1HITjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:39:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38941 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab1HITjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:39:14 -0400
From: <pavan_savoy@ti.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <pavan_savoy@sify.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 0/8] drivers:misc: ti-st: fixes
Date: Tue, 9 Aug 2011 14:38:52 -0500
Message-ID: <1312918749-29627-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>


These are some of the fixes that have gone into the driver during various
testing, production validation stages.
Some are very minor and some impact performance.

Greg,
Packing more patches this time around. Please review

Pavan Savoy (7):
  drivers:misc: ti-st: avoid a misleading dbg msg
  drivers:misc:ti-st: platform hooks for chip states
  drivers:misc: ti-st: reinit completion on ver read
  drivers:misc: ti-st: reinit completion before send
  drivers:misc: ti-st: wait for completion at fail
  drivers:misc: ti-st: free skb on firmware download
  drivers:misc: ti-st: fix unexpected UART close

Vijay Badawadagi (1):
  drivers:misc: ti-st: fail-safe on wrong pkt type

