Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787Ab0FTWt3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:49:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58859 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757487Ab0FTWpz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:45:55 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Mehmet Giritli" <mehmet@giritli.eu>
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
In-Reply-To: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <rHrHQMIU4rI.A.-EB.xapHMB@chimera>
Subject: [Bug #16040] kacpid consumes ~40% of cpu all the time beginning with 2.6.34
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jun 2010 00:34:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16040
Subject		: kacpid consumes ~40% of cpu all the time beginning with 2.6.34
Submitter	: Mehmet Giritli <mehmet@giritli.eu>
Date		: 2010-05-24 07:32 (28 days old)
Patch		: https://patchwork.kernel.org/patch/104903/
		  https://patchwork.kernel.org/patch/104912/
		  https://patchwork.kernel.org/patch/104909/
		  https://patchwork.kernel.org/patch/104911/
		  https://patchwork.kernel.org/patch/104910/


