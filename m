Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0H2Xew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 19:34:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55396 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab0H2X3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 19:29:14 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "boris64" <bugzilla.kernel.org@boris64.net>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <c1_O4wHrlB.A.63.mbueMB@chimera>
In-Reply-To: <c1_O4wHrlB.A.63.mbueMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ByD_7B96czP.A.lND.RgueMB@chimera>
Subject: [Bug #16322] WARNING: at /arch/x86/include/asm/processor.h:1005 read_measured_perf_ctrs+0x5a/0x70()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 30 Aug 2010 01:13:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.34 and 2.6.35.

The following bug entry is on the current list of known regressions
introduced between 2.6.34 and 2.6.35.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16322
Subject		: WARNING: at /arch/x86/include/asm/processor.h:1005 read_measured_perf_ctrs+0x5a/0x70()
Submitter	: boris64 <bugzilla.kernel.org@boris64.net>
Date		: 2010-07-01 13:54 (60 days old)
Handled-By	: H. Peter Anvin <hpa@zytor.com>


