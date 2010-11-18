Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761171Ab0KSANE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 19:13:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35188 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933411Ab0KSAJK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 19:09:10 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Nikola Ciprich" <extmaillist@linuxbox.cz>
References: <tTUH_XeInOH.A.dMF.c3b5MB@chimera>
In-Reply-To: <tTUH_XeInOH.A.dMF.c3b5MB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <t78YtCSuOqN.A.8OG.T4b5MB@chimera>
Subject: [Bug #20462] 2.6.36-rc7-git2 - panic/GPF: e1000e/vlans?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 19 Nov 2010 00:53:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.35 and 2.6.36.

The following bug entry is on the current list of known regressions
introduced between 2.6.35 and 2.6.36.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20462
Subject		: 2.6.36-rc7-git2 - panic/GPF: e1000e/vlans?
Submitter	: Nikola Ciprich <extmaillist@linuxbox.cz>
Date		: 2010-10-15 7:10 (35 days old)
Message-ID	: <20101015071008.GA8714@pcnci.linuxbox.cz>
References	: http://marc.info/?l=linux-kernel&m=128712984831303&w=2


