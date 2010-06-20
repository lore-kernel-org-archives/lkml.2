Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab0FTWvI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:51:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58828 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757282Ab0FTWpT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:45:19 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Matthew Garrett" <mjg@redhat.com>, "Michal Hocko" <mhocko@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Tony Vroon" <tony@linx.net>
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
In-Reply-To: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <rHrHQMIU4rI.A.ksB.7bpHMB@chimera>
Subject: [Bug #15951] commit 9630bdd9 changes behavior of the poweroff
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jun 2010 00:34:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15951
Subject		: commit 9630bdd9 changes behavior of the poweroff
Submitter	: Michal Hocko <mhocko@suse.cz>
Date		: 2010-04-01 13:39 (81 days old)
First-Bad-Commit: http://git.kernel.org/linus/9630bdd9b15d2f489c646d8bc04b60e53eb5ec78
Message-ID	: <20100401133923.GA4104@tiehlicka.suse.cz>
References	: http://marc.info/?l=linux-kernel&m=127012918316305&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
Patch		: https://patchwork.kernel.org/patch/106701/


