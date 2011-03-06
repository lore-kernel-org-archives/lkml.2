Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab1CFMxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 07:53:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56121 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064Ab1CFMxQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 07:53:16 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "=?utf-8?q?Ortwin=20Gl=C3=BCck?=" <odi@odi.ch>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
References: <dtUMITvTCCN.A.uuF.y-3cNB@chimera>
In-Reply-To: <dtUMITvTCCN.A.uuF.y-3cNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sUKqYsqyJ4N.A.14F.8-3cNB@chimera>
Subject: [Bug #29722] kworker consumes ~100% CPU on HP Elitebook 8540w after resume
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Mar 2011 13:40:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.36 and 2.6.37.

The following bug entry is on the current list of known regressions
introduced between 2.6.36 and 2.6.37.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29722
Subject		: kworker consumes ~100% CPU on HP Elitebook 8540w after resume
Submitter	: Ortwin Glück <odi@odi.ch>
Date		: 2011-02-23 11:49 (12 days old)
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
Patch		: https://patchwork.kernel.org/patch/604371/


