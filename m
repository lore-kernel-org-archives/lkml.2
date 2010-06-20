Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab0FTWrM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:47:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58922 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757600Ab0FTWqj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:46:39 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Alex,Shi" <alex.shi@intel.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Eric Dumazet" <eric.dumazet@gmail.com>
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
In-Reply-To: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <rHrHQMIU4rI.A.uWH.-ZpHMB@chimera>
Subject: [Bug #16254] TCP stream performance regression due to c377411f2494a931ff7facdbb3a6839b1266bcf6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jun 2010 00:34:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16254
Subject		: TCP stream performance regression due to c377411f2494a931ff7facdbb3a6839b1266bcf6
Submitter	: Alex,Shi <alex.shi@intel.com>
Date		: 2010-06-18 7:17 (3 days old)
First-Bad-Commit: http://git.kernel.org/linus/c377411f2494a931ff7facdbb3a6839b1266bcf6
Message-ID	: <1276845448.2118.346.camel@debian>
References	: http://marc.info/?l=linux-kernel&m=127684931020672&w=2


