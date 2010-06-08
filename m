Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab0FHWRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 18:17:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39725 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932364Ab0FHWRI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 18:17:08 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Jan Kreuzer" <kontrollator@gmx.de>
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera>
In-Reply-To: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <C9Q3XEnHPeG.A.iXG.b8rDMB@chimera>
Subject: [Bug #16129] BUG: using smp_processor_id() in preemptible [00000000] code: jbd2/sda2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  9 Jun 2010 00:10:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16129
Subject		: BUG: using smp_processor_id() in preemptible [00000000] code: jbd2/sda2
Submitter	: Jan Kreuzer <kontrollator@gmx.de>
Date		: 2010-06-05 06:15 (4 days old)


