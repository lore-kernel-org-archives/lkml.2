Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab1GFSER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:04:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab1GFSEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:04:16 -0400
Date: Wed, 6 Jul 2011 15:03:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv3 07/17] [media] DocBook: Add return error codes to LIRC
 ioctl session
Message-ID: <20110706150355.26257da0@pedra>
In-Reply-To: <cover.1309974026.git.mchehab@redhat.com>
References: <cover.1309974026.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a reference for the generic error code chapter to LIRC ioctl
description.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/v4l/lirc_device_interface.xml b/Documentation/DocBook/media/v4l/lirc_device_interface.xml
index a060f3f..8d7eb6b 100644
--- a/Documentation/DocBook/media/v4l/lirc_device_interface.xml
+++ b/Documentation/DocBook/media/v4l/lirc_device_interface.xml
@@ -246,10 +246,8 @@ on working with the default settings initially.</para>
     </listitem>
   </varlistentry>
 </variablelist>
-
-</section>
-
 <section id="lirc_dev_errors">
-    &return-value;
+  &return-value;
+</section>
 </section>
 </section>
-- 
1.7.1


