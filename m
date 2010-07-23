Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab0GWMSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:18:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51959 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab0GWMSi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:18:38 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Johannes Berg" <johannes@sipsolutions.net>,
        "Nico Schottelius" <nico-linux-20100427@schottelius.org>
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
In-Reply-To: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <PRbv8sgxY6G.A.K4G.aXYSMB@chimera>
Subject: [Bug #15862] 2.6.34-rc4/5: iwlagn unusable until reload
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 23 Jul 2010 14:15:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15862
Subject		: 2.6.34-rc4/5: iwlagn unusable until reload
Submitter	: Nico Schottelius <nico-linux-20100427@schottelius.org>
Date		: 2010-04-27 7:49 (88 days old)
Message-ID	: <20100427074934.GB3261@ikn.schottelius.org>
References	: http://marc.info/?l=linux-kernel&m=127235784004839&w=2
Handled-By	: Johannes Berg <johannes@sipsolutions.net>


