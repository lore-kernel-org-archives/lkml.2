Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab1FZXBT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 19:01:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59708 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907Ab1FZW63 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 18:58:29 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "=?utf-8?q?Ferenc=20W=C3=A1gner?=" <wferi@niif.hu>
References: <fvHbBUhG0PD.A.IGE.HM7BOB@chimera>
In-Reply-To: <fvHbBUhG0PD.A.IGE.HM7BOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Rm1pgFxEGUF.A.XZE.nM7BOB@chimera>
Subject: [Bug #37322] high load, unresponsive system spinning in rcu_kthread
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 27 Jun 2011 00:35:14 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.38 and 2.6.39.

The following bug entry is on the current list of known regressions
introduced between 2.6.38 and 2.6.39.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37322
Subject		: high load, unresponsive system spinning in rcu_kthread
Submitter	: Ferenc Wágner <wferi@niif.hu>
Date		: 2011-06-12 14:53 (15 days old)


