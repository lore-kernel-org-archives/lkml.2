Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878Ab0DHXmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 19:42:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41707 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759190Ab0DHXlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 19:41:52 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "" <johannes.schlatow@googlemail.com>
References: <cjwJ7Pf9h0L.A.9pB.1DmvLB@chimera>
In-Reply-To: <cjwJ7Pf9h0L.A.9pB.1DmvLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <onZ81XwyNTD.A.KnC.zEmvLB@chimera>
Subject: [Bug #15439] Laptop does consume more power when booted "cold" -- Thinkpad X200s
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  9 Apr 2010 01:04:31 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.32 and 2.6.33.

The following bug entry is on the current list of known regressions
introduced between 2.6.32 and 2.6.33.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15439
Subject		: Laptop does consume more power when booted "cold" -- Thinkpad X200s
Submitter	:  <johannes.schlatow@googlemail.com>
Date		: 2010-03-03 23:09 (37 days old)


