Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab1H1Tqo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 15:46:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43629 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308Ab1H1TpS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 15:45:18 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Paul Bolle" <pebolle@tiscali.nl>
References: <Sm7qbRR0zn.A.yAG.LepWOB@chimera>
In-Reply-To: <Sm7qbRR0zn.A.yAG.LepWOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <gUVi6eNP8RE.A.nQG.fepWOB@chimera>
Subject: [Bug #41092] INFO: trying to register non-static key (sync_inodes_sb)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 28 Aug 2011 21:01:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.39 and 3.0.

The following bug entry is on the current list of known regressions
introduced between 2.6.39 and 3.0.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=41092
Subject		: INFO: trying to register non-static key (sync_inodes_sb)
Submitter	: Paul Bolle <pebolle@tiscali.nl>
Date		: 2011-08-13 22:07 (16 days old)


