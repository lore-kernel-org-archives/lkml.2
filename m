Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab1GFSFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:05:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab1GFSFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:05:00 -0400
Date: Wed, 6 Jul 2011 15:03:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv3 04/17] [media] DocBook/media-ioc-setup-link.xml:
 Remove EBUSY
Message-ID: <20110706150352.2162022f@pedra>
In-Reply-To: <cover.1309974026.git.mchehab@redhat.com>
References: <cover.1309974026.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EBUSY is already described as a generic error condition, with a
similar text.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/v4l/media-ioc-setup-link.xml b/Documentation/DocBook/media/v4l/media-ioc-setup-link.xml
index cec97af..fc2e522 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-setup-link.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-setup-link.xml
@@ -72,15 +72,6 @@
 
     <variablelist>
       <varlistentry>
-	<term><errorcode>EBUSY</errorcode></term>
-	<listitem>
-	  <para>The link properties can't be changed because the link is
-	  currently busy. This can be caused, for instance, by an active media
-	  stream (audio or video) on the link. The ioctl shouldn't be retried if
-	  no other action is performed before to fix the problem.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
 	  <para>The &media-link-desc; references a non-existing link, or the
-- 
1.7.1


