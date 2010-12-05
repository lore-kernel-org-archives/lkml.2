Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab0LEUg4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 15:36:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55425 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640Ab0LEUge convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 15:36:34 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "Jan Kara" <jack@suse.cz>,
        "" <markus.gapp@gmx.net>
References: <jyQ21do2hOF.A.qwD.m_--MB@chimera>
In-Reply-To: <jyQ21do2hOF.A.qwD.m_--MB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <z3LGq_ncuOB.A.2gE.oA_-MB@chimera>
Subject: [Bug #21092] Kernel 2.6.36 Bug during quotaon on reiserfs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  5 Dec 2010 21:34:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.35 and 2.6.36.

The following bug entry is on the current list of known regressions
introduced between 2.6.35 and 2.6.36.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=21092
Subject		: Kernel 2.6.36 Bug during quotaon on reiserfs
Submitter	:  <markus.gapp@gmx.net>
Date		: 2010-10-24 16:57 (43 days old)
Handled-By	: Jan Kara <jack@suse.cz>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=35292


