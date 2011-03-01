Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab1CAW7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 17:59:48 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:53627 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756751Ab1CAW7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 17:59:44 -0500
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX18ub5NZVbQui2xTMAlLV60oC+aXdDKbe5MQLr2Sk1
	5jFRGXqGO7iV/W
From: =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Steve Underwood <steveu@coppice.org>, David Rowe <david@rowetel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: [PATCH] staging: echo: fix a typo ("overflow")
Date: Tue,  1 Mar 2011 23:58:54 +0100
Message-Id: <1299020335-11017-1-git-send-email-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
---
 drivers/staging/echo/echo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/echo/echo.c b/drivers/staging/echo/echo.c
index 58c4e90..3c188d5 100644
--- a/drivers/staging/echo/echo.c
+++ b/drivers/staging/echo/echo.c
@@ -544,7 +544,7 @@ int16_t oslec_update(struct oslec_state *ec, int16_t tx, int16_t rx)
 				 * Just random numbers rolled off very vaguely
 				 * Hoth-like.  DR: This noise doesn't sound
 				 * quite right to me - I suspect there are some
-				 * overlfow issues in the filtering as it's too
+				 * overflow issues in the filtering as it's too
 				 * "crackly".
 				 * TODO: debug this, maybe just play noise at
 				 * high level or look at spectrum.
-- 
1.7.4.1

