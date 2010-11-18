Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761182Ab0KSANF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 19:13:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35181 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761116Ab0KSAJI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 19:09:08 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Prasad Joshi" <prasadjoshi124@gmail.com>
References: <tTUH_XeInOH.A.dMF.c3b5MB@chimera>
In-Reply-To: <tTUH_XeInOH.A.dMF.c3b5MB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <t78YtCSuOqN.A.ufG.Y4b5MB@chimera>
Subject: [Bug #20342] [LogFS] [2.6.36-rc7] Deadlock in logfs_get_wblocks, hold and wait on same lock super->s_write_mutex
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 19 Nov 2010 00:53:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.35 and 2.6.36.

The following bug entry is on the current list of known regressions
introduced between 2.6.35 and 2.6.36.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20342
Subject		: [LogFS] [2.6.36-rc7] Deadlock in logfs_get_wblocks, hold and wait on same lock super->s_write_mutex
Submitter	: Prasad Joshi <prasadjoshi124@gmail.com>
Date		: 2010-10-13 9:49 (37 days old)
Message-ID	: <AANLkTinvsMxTxEbDEFmb5M-6fYjdRvErU==Zs7+qANkV@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=128696335024718&w=2


