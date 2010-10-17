Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855Ab0JQU0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 16:26:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54580 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932801Ab0JQU0r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 16:26:47 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Patrizio Bassi" <patrizio.bassi@gmail.com>
References: <TP5BfCZNRXD.A._8.uj1uMB@chimera>
In-Reply-To: <TP5BfCZNRXD.A._8.uj1uMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7N-qxsaxKCN.A.6BC.Uk1uMB@chimera>
Subject: [Bug #20032] 2.6.36-rc7 continuos kernel panics due to of cpu_idle (and cpu_intel_idle)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 17 Oct 2010 22:21:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.35.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20032
Subject		: 2.6.36-rc7 continuos kernel panics due to of cpu_idle (and cpu_intel_idle)
Submitter	: Patrizio Bassi <patrizio.bassi@gmail.com>
Date		: 2010-10-08 18:23 (10 days old)
Message-ID	: <AANLkTi=2irM5tM2rNC5wHVV=Nw4cs_CK59pvXDD+Y5Dz@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=128656222919323&w=2


