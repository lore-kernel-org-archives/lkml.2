Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab0JQUZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 16:25:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54519 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932718Ab0JQUZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 16:25:30 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "Meelis Roos" <mroos@linux.ee>
References: <TP5BfCZNRXD.A._8.uj1uMB@chimera>
In-Reply-To: <TP5BfCZNRXD.A._8.uj1uMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7N-qxsaxKCN.A.kUD.Km1uMB@chimera>
Subject: [Bug #16971] qla4xxx compile failure on 32-bit PowerPC: missing readq and writeq
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 17 Oct 2010 22:21:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.35.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16971
Subject		: qla4xxx compile failure on 32-bit PowerPC: missing readq and writeq
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2010-08-19 21:03 (60 days old)
Message-ID	: <<alpine.SOC.1.00.1008192359310.19654@math.ut.ee>>
References	: http://marc.info/?l=linux-kernel&m=128225184900892&w=2


