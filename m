Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab1GJLHp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 07:07:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42454 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848Ab1GJLFs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 07:05:48 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "" <farbing@web.de>,
        "Jeff Layton" <jlayton@redhat.com>
References: <Y7LyOsOBwFM.A.kJG.kBYGOB@chimera>
In-Reply-To: <Y7LyOsOBwFM.A.kJG.kBYGOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <XNkIyhV6dgF.A.BVG.xBYGOB@chimera>
Subject: [Bug #38972] Kernel panic when syncing while cifs is mounted
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jul 2011 12:38:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.39.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38972
Subject		: Kernel panic when syncing while cifs is mounted
Submitter	:  <farbing@web.de>
Date		: 2011-07-08 15:39 (3 days old)
First-Bad-Commit: http://git.kernel.org/linus/dd8544661947ad6d8d87b3c9d4333bfa1583d1bc
Handled-By	: Jeff Layton <jlayton@redhat.com>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=65082


