Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab0LEUj4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 15:39:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55416 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994Ab0LEUgc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 15:36:32 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Luis R. Rodriguez" <mcgrof@gmail.com>
References: <jyQ21do2hOF.A.qwD.m_--MB@chimera>
In-Reply-To: <jyQ21do2hOF.A.qwD.m_--MB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <z3LGq_ncuOB.A.hcE.kA_-MB@chimera>
Subject: [Bug #21372] NULL pointer deference at disk_replace_part_tbl+0x32
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  5 Dec 2010 21:34:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.35 and 2.6.36.

The following bug entry is on the current list of known regressions
introduced between 2.6.35 and 2.6.36.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=21372
Subject		: NULL pointer deference at disk_replace_part_tbl+0x32
Submitter	: Luis R. Rodriguez <mcgrof@gmail.com>
Date		: 2010-10-28 17:22 (39 days old)


