Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab1GFS2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:28:19 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:39275 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab1GFS2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:28:18 -0400
Date: Wed, 6 Jul 2011 11:27:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Documentation: update CodingStyle memory allocators
Message-Id: <20110706112717.cf70425e.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4E14A920.0090:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>

The list of available general purpose memory allocators in
Documentation/CodingStyle chapter 14 is incomplete. This patch adds
the missing vzalloc() to the list.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/CodingStyle |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx-30-rc4.orig/Documentation/CodingStyle
+++ lnx-30-rc4/Documentation/CodingStyle
@@ -680,8 +680,8 @@ ones already enabled by DEBUG.
 		Chapter 14: Allocating memory
 
 The kernel provides the following general purpose memory allocators:
-kmalloc(), kzalloc(), kcalloc(), and vmalloc().  Please refer to the API
-documentation for further information about them.
+kmalloc(), kzalloc(), kcalloc(), vmalloc(), and vzalloc().  Please refer to
+the API documentation for further information about them.
 
 The preferred form for passing a size of a struct is the following:
 
