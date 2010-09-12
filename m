Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab0ILT3b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 15:29:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47430 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab0ILT32 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 15:29:28 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Matthias Dahl" <ml_kernel@mortal-soul.de>
References: <QnCvudbe2FD.A.XiE.DgSjMB@chimera>
In-Reply-To: <QnCvudbe2FD.A.XiE.DgSjMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <p44oKaOqEDM.A.J8E.YgSjMB@chimera>
Subject: [Bug #17732] [2.6.35.x regression] rcu_preempt_state stall warning and machine slow-downs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 12 Sep 2010 21:08:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.34 and 2.6.35.

The following bug entry is on the current list of known regressions
introduced between 2.6.34 and 2.6.35.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17732
Subject		: [2.6.35.x regression] rcu_preempt_state stall warning and machine slow-downs
Submitter	: Matthias Dahl <ml_kernel@mortal-soul.de>
Date		: 2010-09-01 6:47 (12 days old)
Message-ID	: <201009010847.20236.ml_kernel@mortal-soul.de>
References	: http://marc.info/?l=linux-kernel&m=128332418629305&w=2


