Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab2J1L4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 07:56:35 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:46787 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab2J1L4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 07:56:34 -0400
Date: Sun, 28 Oct 2012 12:56:33 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] hidraw: add a .gitignore entry for samples/hidraw/hid-example
Message-ID: <20121028115633.GF11953@order.stressinduktion.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
---
 samples/hidraw/.gitignore | 2 ++
 1 file changed, 2 insertions(+)
 create mode 100644 samples/hidraw/.gitignore

diff --git a/samples/hidraw/.gitignore b/samples/hidraw/.gitignore
new file mode 100644
index 0000000..b1bdafd
--- /dev/null
+++ b/samples/hidraw/.gitignore
@@ -0,0 +1,2 @@
+/hid-example
+
