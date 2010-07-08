Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923Ab0GHX5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:57:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37849 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab0GHX5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:57:37 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Dmitry Monakhov" <dmonakhov@openvz.org>,
       "Sedat Dilek" <sedat.dilek@googlemail.com>,
       "Sergey Senozhatsky" <sergey.senozhatsky@gmail.com>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
In-Reply-To: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TXb9XdQzJoD.A.SIE.FOmNMB@chimera>
Subject: [Bug #16169] Complain from preemptive debug
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  9 Jul 2010 01:41:33 +0200 (CEST)
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
Date		: 2010-05-31 10:10 (39 days old)
Message-ID	: <AANLkTilTnAAZIizKinYsxFkNTkrmPqk6XJJuUjjhJ7EP@mail.gmail.com>
References	: http://lkml.org/lkml/2010/5/31/77
Handled-By	: Dmitry Monakhov <dmonakhov@openvz.org>
		  Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Patch		: http://www.spinics.net/lists/cpufreq/msg01631.html
		  https://patchwork.kernel.org/patch/106555/


