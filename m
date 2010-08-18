Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab0HRQaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:30:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594Ab0HRQaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:30:06 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/5] fanotify: add MAINTAINERS entry
To: linux-kernel@vger.kernel.org
Date: Wed, 18 Aug 2010 12:30:05 -0400
Message-ID: <20100818163005.1080.81967.stgit@paris.rdu.redhat.com>
In-Reply-To: <20100818162954.1080.48055.stgit@paris.rdu.redhat.com>
References: <20100818162954.1080.48055.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add myself as the maintainer.

Reported-by: Andy Gospodarek <gospo@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com
---

 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2c07d55..fb321c2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2299,6 +2299,12 @@ S:	Maintained
 F:	Documentation/hwmon/f71805f
 F:	drivers/hwmon/f71805f.c
 
+FANOTIFY
+M:	Eric Paris <eparis@redhat.com>
+S:	Maintained
+F:	fs/notify/fanotify/
+F:	include/linux/fanotify.h
+
 FARSYNC SYNCHRONOUS DRIVER
 M:	Kevin Curtis <kevin.curtis@farsite.co.uk>
 W:	http://www.farsite.co.uk/

