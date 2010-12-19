Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab0LSM7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 07:59:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38667 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756643Ab0LSM4Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 07:56:16 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "Dave Jones" <davej@redhat.com>
References: <ZRNlsjykcOD.A.b-F.20fDNB@chimera>
In-Reply-To: <ZRNlsjykcOD.A.b-F.20fDNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <xqq2Z3iR9HJ.A.kJH.J2fDNB@chimera>
Subject: [Bug #20322] 2.6.36-rc7: inconsistent lock state: inconsistent {IN-RECLAIM_FS-R} -> {RECLAIM_FS-ON-W} usage.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 19 Dec 2010 13:50:24 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.35 and 2.6.36.

The following bug entry is on the current list of known regressions
introduced between 2.6.35 and 2.6.36.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20322
Subject		: 2.6.36-rc7: inconsistent lock state: inconsistent {IN-RECLAIM_FS-R} -> {RECLAIM_FS-ON-W} usage.
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2010-10-11 20:10 (70 days old)
Message-ID	: <20101011201007.GA29707@redhat.com>
References	: http://marc.info/?l=linux-kernel&m=128682782828453&w=2


