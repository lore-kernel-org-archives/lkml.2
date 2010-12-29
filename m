Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab0L2XQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 18:16:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40149 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265Ab0L2XQR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 18:16:17 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Don Zickus" <dzickus@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Yinghai Lu" <yinghai@kernel.org>
References: <96DQe4a_2tH.A.4RE.497GNB@chimera>
In-Reply-To: <96DQe4a_2tH.A.4RE.497GNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sV7shrPOroO.A.M0F._-7GNB@chimera>
Subject: [Bug #24362] perf hw  in kexeced kernel broken in tip
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 30 Dec 2010 00:07:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.36.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24362
Subject		: perf hw  in kexeced kernel broken in tip
Submitter	: Yinghai Lu <yinghai@kernel.org>
Date		: 2010-12-01 8:00 (29 days old)
First-Bad-Commit: http://git.kernel.org/linus/33c6d6a7ad0ffab9b1b15f8e4107a2af072a05a0
Message-ID	: <4CF60095.1020900@kernel.org>
References	: http://marc.info/?l=linux-kernel&m=129119055922065&w=2


