Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab2HPELO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 00:11:14 -0400
Received: from home.kolivas.org ([59.167.196.135]:43061 "EHLO mine.kolivas.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751363Ab2HPELN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 00:11:13 -0400
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2012 00:11:13 EDT
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE} 3.5-ck1, BFS scheduler v0.24 for linux-3.5
Date: Thu, 16 Aug 2012 14:01:57 +1000
Message-ID: <8971169.b7BdNZJbZy@hex>
User-Agent: KMail/4.9 (Linux/3.5.1-ck1; KDE/4.9.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are patches designed to improve system responsiveness and
interactivity with specific emphasis on the desktop, but suitable to
any commodity hardware workload.

Apply to 3.5.x:
http://ck.kolivas.org/patches/3.0/3.5/3.5-ck1/patch-3.5-ck1.bz2
or
http://ck.kolivas.org/patches/3.0/3.5/3.5-ck1/patch-3.5-ck1.lrz

Broken out tarball:
http://ck.kolivas.org/patches/3.0/3.5/3.5-ck1/3.5-ck1-broken-out.tar.bz2
or
http://ck.kolivas.org/patches/3.0/3.5/3.5-ck1/3.5-ck1-broken-out.tar.lrz

Discrete patches:
http://ck.kolivas.org/patches/3.0/3.5/3.5-ck1/patches/

Latest BFS by itself:
http://ck.kolivas.org/patches/bfs/3.5.0/3.5-sched-bfs-424.patch

Web:
http://kernel.kolivas.org

Code blog when I feel like it:
http://ck-hack.blogspot.com/


This is a resync from 3.4-ck3. However, the broken out tarballs above also 
include the upgradeable rwlocks patch, and a modification of the global 
runqueue in BFS to use the urwlocks. These are NOT applied in the -ck1 patch, 
but can be applied manually at the  end of the series as indicated by the 
series file. It is currently of no demonstrable performance advantage OR 
detriment in its current state, but is code for future development.

Enjoy!
お楽しみください

-- 
-ck
