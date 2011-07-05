Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab1GEQo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:44:26 -0400
Received: from mail.perches.com ([173.55.12.10]:3545 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022Ab1GEQmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:42:23 -0400
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Subject: =?UTF-8?q?=5BPATCH=2006/14=5D=20MAINTAINERS=3A=20Add=20STAGING=20-=20HYPER-V=20=28MICROSOFT=29?=
Date: Tue,  5 Jul 2011 09:42:06 -0700
Message-Id: <378efa159b4826fde9015501ac5d94d26e0f3df9.1309883752.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
In-Reply-To: <cover.1309883752.git.joe@perches.com>
References: <20110704153435.GA17475@suse.de> <cover.1309883752.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9c7baa9..70ccf25 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6099,6 +6099,12 @@ M:	David Täht <d@teklibre.com>
 S:	Odd Fixes
 F:	drivers/staging/frontier/
 
+STAGING - HYPER-V (MICROSOFT)
+M:	Hank Janssen <hjanssen@microsoft.com>
+M:	Haiyang Zhang <haiyangz@microsoft.com>
+S:	Odd Fixes
+F:	drivers/staging/hv/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.6.131.g99019

