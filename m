Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab0FTW2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:28:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58568 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047Ab0FTW21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:28:27 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Dmitry Monakhov" <dmonakhov@openvz.org>,
       "Sedat Dilek" <sedat.dilek@googlemail.com>
References: <lc60d4toGTL.A.QzD._LpHMB@chimera>
In-Reply-To: <lc60d4toGTL.A.QzD._LpHMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <W8JfMs9cZw.A.PcG.hNpHMB@chimera>
Subject: [Bug #16169] Complain from preemptive debug
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jun 2010 00:17:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16169
Subject		: Complain from preemptive debug
Submitter	: Sedat Dilek <sedat.dilek@googlemail.com>
Date		: 2010-05-31 10:10 (21 days old)
Message-ID	: <AANLkTilTnAAZIizKinYsxFkNTkrmPqk6XJJuUjjhJ7EP@mail.gmail.com>
References	: http://lkml.org/lkml/2010/5/31/77
Handled-By	: Dmitry Monakhov <dmonakhov@openvz.org>
Patch		: http://www.spinics.net/lists/cpufreq/msg01631.html


