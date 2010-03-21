Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab0CUVCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 17:02:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59522 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898Ab0CUVCh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 17:02:37 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Eric Anholt" <eric@anholt.net>, "Justin Madru" <jdm64@gawab.com>
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera>
In-Reply-To: <QQGfxbJf48H.A.NFD.uNopLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <hTwaxgnIZ2O.A.FaD._NopLB@chimera>
Subject: [Bug #15527] [BUG] NULL pointer dereference in i915_gem_object_save_bit_17_swizzle
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Mar 2010 21:30:52 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.32 and 2.6.33.

The following bug entry is on the current list of known regressions
introduced between 2.6.32 and 2.6.33.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15527
Subject		: [BUG] NULL pointer dereference in i915_gem_object_save_bit_17_swizzle
Submitter	: Justin Madru <jdm64@gawab.com>
Date		: 2010-03-04 9:00 (18 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/280b713b5b0fd84cf2469098aee88acbb5de859c
Message-ID	: <20100304090047.23689.qmail@info88.gawab.com>
References	: http://marc.info/?l=linux-kernel&m=126769366716380&w=2


