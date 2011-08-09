Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab1HITmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:42:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53982 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab1HITjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:39:15 -0400
From: <pavan_savoy@ti.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <pavan_savoy@sify.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 0/8] drivers:misc: ti-st: fixes
Date: Tue, 9 Aug 2011 14:39:01 -0500
Message-ID: <1312918749-29627-10-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1312918749-29627-9-git-send-email-pavan_savoy@ti.com>
References: <1312918749-29627-1-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-2-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-3-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-4-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-5-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-6-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-7-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-8-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-9-git-send-email-pavan_savoy@ti.com>
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

