Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab0ILTao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 15:30:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47428 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146Ab0ILT30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 15:29:26 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
        "M. Vefa Bicakci" <bicave@superonline.com>
References: <QnCvudbe2FD.A.XiE.DgSjMB@chimera>
In-Reply-To: <QnCvudbe2FD.A.XiE.DgSjMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <p44oKaOqEDM.A.sEF.lgSjMB@chimera>
Subject: [Bug #16771] [Bisected Regression in 2.6.35] A full tmpfs filesystem causes hibernationto hang
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 12 Sep 2010 21:08:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.34 and 2.6.35.

The following bug entry is on the current list of known regressions
introduced between 2.6.34 and 2.6.35.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16771
Subject		: [Bisected Regression in 2.6.35] A full tmpfs filesystem causes hibernationto hang
Submitter	: M. Vefa Bicakci <bicave@superonline.com>
Date		: 2010-08-15 5:25 (29 days old)
First-Bad-Commit: http://git.kernel.org/linus/bb21c7ce18eff8e6e7877ca1d06c6db719376e3c
Message-ID	: <4C677A49.4030904@superonline.com>
References	: http://marc.info/?l=linux-kernel&m=128184995401968&w=2


