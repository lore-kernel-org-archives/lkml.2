Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab1JGVwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 17:52:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48917 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab1JGVwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 17:52:53 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 1/4] staging: et131x: Removing Olaf Hartmann's email as it bounces
Date: Fri,  7 Oct 2011 22:51:27 +0100
Message-Id: <1318024287-10221-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 October 2011 18:51, Uwe Ranft <uwe.ranft@telozo.com> wrote:
> Hello,
> olaf is not more longer owner of this e-mailadress. he has left our
> company.
> Please remove olaf fron the mailing list!
> Best Regards
> Uwe

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/README |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/et131x/README b/drivers/staging/et131x/README
index b262ec7..d383e80 100644
--- a/drivers/staging/et131x/README
+++ b/drivers/staging/et131x/README
@@ -2,7 +2,7 @@ This is a driver for the ET1310 network device.
 
 Based on the driver found at https://sourceforge.net/projects/et131x/
 
-Cleaned up immensely by Olaf Hartman <o.hartmann@telovital.com> and Christoph
+Cleaned up immensely by Olaf Hartman and Christoph
 Hellwig <hch@infradead.org>
 
 Note, the powermanagement options were removed from the vendor provided
@@ -14,6 +14,3 @@ Please send patches to:
 	Greg Kroah-Hartman <gregkh@suse.de>
 	Mark Einon <mark.einon@gmail.com>
 
-And Cc: Olaf Hartmann <o.hartmann@telovital.com> as he has this device and can
-test any changes.
-
-- 
1.7.6.4

