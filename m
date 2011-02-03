Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab1BCLKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 06:10:24 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37001 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab1BCLKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 06:10:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uq8GipwVQ9q/2uy9f4uwxlGg4yEZo+c5jvrwiXCR8YBNrtnoA4DMAX13SxrrHL8Ys0
         KRdZH6mgywixzGMV3C66+MdyWfSuKJ+jHvdruUod7WctFOlWbuMls7kF1o+V8uDsQRyh
         tyj9fw6ptqpTQx0meaPBmuVznHCEs0Yjrix6I=
From: Tommi Rantala <tt.rantala@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Tommi Rantala <tt.rantala@gmail.com>, Eric Paris <eparis@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <jaxboe@fusionio.com>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] include: install kernel-page-flags.h for user space
Date: Thu,  3 Feb 2011 13:09:04 +0200
Message-Id: <1296731344-10290-1-git-send-email-tt.rantala@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Install the header, commit 1a9b5b7 tells us that it is for user space.

Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
---
 include/linux/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 2296d8b..90374d9 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -219,6 +219,7 @@ header-y += jffs2.h
 header-y += joystick.h
 header-y += kd.h
 header-y += kdev_t.h
+header-y += kernel-page-flags.h
 header-y += kernel.h
 header-y += kernelcapi.h
 header-y += keyboard.h
-- 
1.7.1

