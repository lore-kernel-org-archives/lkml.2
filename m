Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab1CCBPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 20:15:44 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:47915 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab1CCBPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 20:15:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hzsswTlGOBepYjiq2ARxDbPWsQNfsU/nzjmAndmxA3dEurdm9VzDKGtipUqJ4wck4/
         Cr21Dw4U+fgJ7ulRU5/tcb/o2Qy7bmU0WnHnY/Tz5CNaue5GqaZHwGn5p+DokrKceWnG
         ggyNJ3V4OFmfXMuNNf3UykBhRh4AzP7xzuEpM=
Subject: [PATCH 0/2] [TRIVIAL] cgroup:doc Update documentation of cgroup
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Private
Date: Thu, 03 Mar 2011 10:15:34 +0900
Message-Id: <1299114934.10998.16.camel@centos55>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jiri Kosina, 

This is a trivial patch for cgroups/cpuset feature. 
Current document file for cgroups/cpuset is still not updated. 
So, I made this patch based on linux-2.6.38-rc7.

Regards,
Geunsik Lim. 

== CUT HERE ==

>From c9d5de47e369a63164bb04d0c39eaee39d87e8b5 Mon Sep 17 00:00:00 2001
From: Geunsik Lim <geunsik.lim@samsung.com>
Date: Thu, 3 Mar 2011 09:58:11 +0900
Subject: [PATCH 0/2] cgroup:doc Update documentation of cgroup

This patch is for updating contents of cgroup doc based on Linux-2.6.38-rc7.
For example, 
cpuset list, valid website according to cset(python), suitable words. 

Geunsik Lim (2):
  Update cpuset info & webiste via cgroup.
  Update suitable words to explain cgroups.

 Documentation/cgroups/cgroups.txt |   12 ++++++------
 Documentation/cgroups/cpusets.txt |   17 +++++++++--------
 2 files changed, 15 insertions(+), 14 deletions(-)




-----------------------------------------------
To unsubscribe from this list: send the line "unsubscribe linux-***" 
in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

GeunSik Lim ( Samsung Electronics )
e-Mail  :1) geunsik.lim@samsung.com
         2) leemgs@gmail.com , leemgs1@gmail.com
HomePage: http://blog.naver.com/invain/
-----------------------------------------------

