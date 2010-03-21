Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab0CUVB2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 17:01:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59430 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744Ab0CUVBS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 17:01:18 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Johannes Hirte" <johannes.hirte@fem.tu-ilmenau.de>
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera>
In-Reply-To: <QQGfxbJf48H.A.NFD.uNopLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <hTwaxgnIZ2O.A.7MF.7PopLB@chimera>
Subject: [Bug #15246] BUG: Bad page state in process portageq
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Mar 2010 21:30:46 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.32 and 2.6.33.

The following bug entry is on the current list of known regressions
introduced between 2.6.32 and 2.6.33.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15246
Subject		: BUG: Bad page state in process portageq
Submitter	: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Date		: 2010-02-07 0:45 (43 days old)
References	: http://marc.info/?l=linux-kernel&m=126550356515887&w=2


