Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab1BVAwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 19:52:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45724 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab1BVAwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 19:52:22 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Florian Kriener" <florian@kriener.org>
References: <JwKd6rET8XO.A._ZC.gbuYNB@chimera>
In-Reply-To: <JwKd6rET8XO.A._ZC.gbuYNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <f14qsMvj2tF.A.zcD.tcuYNB@chimera>
Subject: [Bug #26612] BUG in fs/inode.c:429
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 21 Feb 2011 23:37:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.36 and 2.6.37.

The following bug entry is on the current list of known regressions
introduced between 2.6.36 and 2.6.37.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=26612
Subject		: BUG in fs/inode.c:429
Submitter	: Florian Kriener <florian@kriener.org>
Date		: 2011-01-06 16:35 (47 days old)
Message-ID	: <201101061735.40060.florian@kriener.org>
References	: http://marc.info/?l=linux-kernel&m=129433235223735&w=2


