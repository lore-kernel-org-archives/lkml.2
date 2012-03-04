Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab2CDUto (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 15:49:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54476 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488Ab2CDUtl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 15:49:41 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "Duncan" <1i5t5.duncan@cox.net>,
        "Jiri Kosina" <jkosina@suse.cz>
References: <FNlNbnGKWLP.A.dME.3F9UPB@chimera>
In-Reply-To: <FNlNbnGKWLP.A.dME.3F9UPB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <hq7dqombK_C.A.UsF.mG9UPB@chimera>
Subject: [Bug #42649] Regression 3.2 -> 3.3-rc1 commit b4b583d4 inet/media keyboard: stuck "extra" keys
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  4 Mar 2012 21:29:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 3.2.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42649
Subject		: Regression 3.2 -> 3.3-rc1 commit b4b583d4 inet/media keyboard: stuck "extra" keys
Submitter	: Duncan <1i5t5.duncan@cox.net>
Date		: 2012-01-24 18:18 (41 days old)
First-Bad-Commit: http://git.kernel.org/linus/b4b583d4e9a5ff28c4a150bb25a4fff5cd4dfbbd


