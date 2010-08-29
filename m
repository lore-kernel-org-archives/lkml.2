Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab0H2XaO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 19:30:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55420 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab0H2X3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 19:29:51 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Claudio M. Camacho" <claudiomkd@gmail.com>
References: <c1_O4wHrlB.A.63.mbueMB@chimera>
In-Reply-To: <c1_O4wHrlB.A.63.mbueMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ByD_7B96czP.A.i9B.MdueMB@chimera>
Subject: [Bug #16495] Kernel 2.6.35 takes almost half an hour to boot
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 30 Aug 2010 01:13:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.34 and 2.6.35.

The following bug entry is on the current list of known regressions
introduced between 2.6.34 and 2.6.35.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16495
Subject		: Kernel 2.6.35 takes almost half an hour to boot
Submitter	: Claudio M. Camacho <claudiomkd@gmail.com>
Date		: 2010-08-02 17:16 (28 days old)


