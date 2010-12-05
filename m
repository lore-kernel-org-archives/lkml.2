Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab0LEUfn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 15:35:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55351 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443Ab0LEUfk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 15:35:40 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Thomas Meyer" <thomas@m3y3r.de>
References: <jyQ21do2hOF.A.qwD.m_--MB@chimera>
In-Reply-To: <jyQ21do2hOF.A.qwD.m_--MB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <z3LGq_ncuOB.A.KYF.VB_-MB@chimera>
Subject: [Bug #19802] [drm:init_ring_common] *ERROR* render ring head not reset to zero
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  5 Dec 2010 21:34:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.35 and 2.6.36.

The following bug entry is on the current list of known regressions
introduced between 2.6.35 and 2.6.36.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19802
Subject		: [drm:init_ring_common] *ERROR* render ring head not reset to zero
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2010-10-04 20:31 (63 days old)
Message-ID	: <201010042231.20320.thomas@m3y3r.de>
References	: http://marc.info/?l=linux-kernel&m=128622441331199&w=2


