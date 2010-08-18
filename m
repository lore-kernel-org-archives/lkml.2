Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab0HRMsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 08:48:19 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:51598 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab0HRMsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 08:48:18 -0400
Date: Wed, 18 Aug 2010 21:48:13 +0900
From: Simon Horman <horms@verge.net.au>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Eric Biederman <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch] MAINTAINERS: kexec-tools has moved
Message-ID: <20100818124813.GK9073@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kexec tools has been moved to http://kernel.org/pub/linux/utils/kernel/kexec/
as user-space code shouldn't be in /pub/linux/kernel

Signed-off-by: Simon Horman <horms@verge.net.au>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

--- 

Andrew, can you push this?

Index: linux-2.6/MAINTAINERS
===================================================================
--- linux-2.6.orig/MAINTAINERS	2010-07-29 13:10:04.000000000 +0900
+++ linux-2.6/MAINTAINERS	2010-07-29 13:11:40.000000000 +0900
@@ -3334,7 +3334,7 @@ F:	drivers/s390/kvm/
 
 KEXEC
 M:	Eric Biederman <ebiederm@xmission.com>
-W:	http://ftp.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
+W:	http://kernel.org/pub/linux/utils/kernel/kexec/
 L:	kexec@lists.infradead.org
 S:	Maintained
 F:	include/linux/kexec.h
