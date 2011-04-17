Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab1DQM5I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 08:57:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56644 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab1DQM5B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 08:57:01 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Bart Van Assche" <bart.vanassche@gmail.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera>
In-Reply-To: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <_H4l51C1wXN.A.yDC.yGuqNB@chimera>
Subject: [Bug #32982] Kernel locks up a few minutes after boot
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 17 Apr 2011 14:57:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.38.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=32982
Subject		: Kernel locks up a few minutes after boot
Submitter	: Bart Van Assche <bart.vanassche@gmail.com>
Date		: 2011-04-10 19:55 (8 days old)


