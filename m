Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936Ab0GWMT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:19:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51992 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759851Ab0GWMTW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:19:22 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "armin walland" <a.walland@focusmr.com>
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
In-Reply-To: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <PRbv8sgxY6G.A.5JG.rVYSMB@chimera>
Subject: [Bug #16137] Ooops in BTRFS in 2.6.34 / x86_64 when mounting subvolume by name
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 23 Jul 2010 14:15:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16137
Subject		: Ooops in BTRFS in 2.6.34 / x86_64 when mounting subvolume by name
Submitter	: armin walland <a.walland@focusmr.com>
Date		: 2010-05-27 12:27 (58 days old)
Message-ID	: <201005271428.01239.a.walland@focusmr.com>
References	: http://marc.info/?l=linux-kernel&m=127496434110736&w=2


