Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab0CTWpj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 18:45:39 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:48523 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752393Ab0CTWpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 18:45:38 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] input: mt: update the status of the Multitouch X driver project
Date: Sat, 20 Mar 2010 23:19:56 +0100
Message-Id: <1269123596-2674-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1Nt72x-00083s-6P.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Nt72x-00083s-6P 425fa7646be3825034a954ef0fb43e30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Multitouch X driver project has moved to alpha status.
This patch updates the documentation accordingly.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 Documentation/input/multi-touch-protocol.txt |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
index eacb226..c0fc1c7 100644
--- a/Documentation/input/multi-touch-protocol.txt
+++ b/Documentation/input/multi-touch-protocol.txt
@@ -233,11 +233,6 @@ where examples can be found.
 difference between the contact position and the approaching tool position
 could be used to derive tilt.
 [2] The list can of course be extended.
-[3] The multi-touch X driver is currently in the prototyping stage. At the
-time of writing (April 2009), the MT protocol is not yet merged, and the
-prototype implements finger matching, basic mouse support and two-finger
-scrolling. The project aims at improving the quality of current multi-touch
-functionality available in the Synaptics X driver, and in addition
-implement more advanced gestures.
+[3] Multitouch X driver project: http://bitmath.org/code/multitouch/.
 [4] See the section on event computation.
 [5] See the section on finger tracking.
-- 
1.6.3.3

