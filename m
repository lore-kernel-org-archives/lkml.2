Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab0GIACX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 20:02:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38004 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759041Ab0GIAAT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 20:00:19 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "=?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?=" <edwintorok@gmail.com>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
In-Reply-To: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TXb9XdQzJoD.A.Aq.5LmNMB@chimera>
Subject: [Bug #16329] 2.6.35-rc3: Load average climbing to 3+ with no apparent reason: CPU 98% idle, with hardly no I/O
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  9 Jul 2010 01:41:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16329
Subject		: 2.6.35-rc3: Load average climbing to 3+ with no apparent reason: CPU 98% idle, with hardly no I/O
Submitter	: Török Edwin <edwintorok@gmail.com>
Date		: 2010-07-01 7:40 (8 days old)
Message-ID	: <20100701104022.404410d6@debian>
References	: http://marc.info/?l=linux-kernel&m=127797005030536&w=2


