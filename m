Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab2BWXWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:22:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39810 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046Ab2BWXWH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:22:07 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "Bret Towe" <magnade@gmail.com>
References: <1qKPXd1RqtP.A.wjG.ShsRPB@chimera>
In-Reply-To: <1qKPXd1RqtP.A.wjG.ShsRPB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <JM4ZOHxb-FL.A.TVH.rhsRPB@chimera>
Subject: [Bug #42571] BUG in ofcs2_change_file_space
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 24 Feb 2012 00:05:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 3.1 and 3.2.

The following bug entry is on the current list of known regressions
introduced between 3.1 and 3.2.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42571
Subject		: BUG in ofcs2_change_file_space
Submitter	: Bret Towe <magnade@gmail.com>
Date		: 2012-01-05 22:23 (50 days old)
Message-ID	: <CALjC5haTNDMOTDPL1m1uBTc2a-Qb8cvR44SCaVDFMzGc+Gw3+w@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=132580236211209&w=2
Patch		: http://oss.oracle.com/pipermail/ocfs2-devel/2012-January/008464.html


