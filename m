Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab0FTWpr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:45:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58845 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757202Ab0FTWpW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:45:22 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, "CaT" <cat@zip.com.au>,
       "Joel Becker" <joel.becker@oracle.com>,
       "Wengang Wang" <wen.gang.wang@oracle.com>
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
In-Reply-To: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <rHrHQMIU4rI.A.dQB.2apHMB@chimera>
Subject: [Bug #16034] 2.6.34: dlm: possible circular locking dependency detected
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16034
Subject		: 2.6.34: dlm: possible circular locking dependency detected
Submitter	: CaT <cat@zip.com.au>
Date		: 2010-05-21 6:59 (31 days old)
Message-ID	: <20100521065933.GH2657@zip.com.au>
References	: http://marc.info/?l=linux-kernel&m=127442519608471&w=2


