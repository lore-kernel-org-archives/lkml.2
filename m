Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1BVACS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 19:02:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45635 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab1BVACI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 19:02:08 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Daniel Poelzleithner" <bugzilla.kernel.org@poelzi.org>
References: <JwKd6rET8XO.A._ZC.gbuYNB@chimera>
In-Reply-To: <JwKd6rET8XO.A._ZC.gbuYNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <f14qsMvj2tF.A.kfC.pbuYNB@chimera>
Subject: [Bug #28772] oops in nfs_revalidate_mapping
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 21 Feb 2011 23:37:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.36 and 2.6.37.

The following bug entry is on the current list of known regressions
introduced between 2.6.36 and 2.6.37.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28772
Subject		: oops in nfs_revalidate_mapping
Submitter	: Daniel Poelzleithner <bugzilla.kernel.org@poelzi.org>
Date		: 2011-02-10 13:59 (12 days old)


