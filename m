Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab2KMMaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 07:30:10 -0500
Received: from mx1.unsolicited.net ([173.255.193.191]:47076 "EHLO
	mx1.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab2KMMaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 07:30:08 -0500
X-Greylist: delayed 997 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Nov 2012 07:30:08 EST
Message-ID: <20121113121329.94457adzis4fk5t5@vinovium.com>
Date: Tue, 13 Nov 2012 12:13:29 +0000
From: David R <david@unsolicited.net>
To: linux-kernel@vger.kernel.org
Subject: Sched - trivial spelling patch
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spell "logarithmic" correctly in sched debug.

--- kernel/sched/debug.c.orig   2012-11-13 11:52:59.000000000 +0000
+++ kernel/sched/debug.c        2012-11-13 11:53:30.000000000 +0000
@@ -318,7 +318,7 @@

  static const char *sched_tunable_scaling_names[] = {
         "none",
-       "logaritmic",
+       "logarithmic",
         "linear"
  };


