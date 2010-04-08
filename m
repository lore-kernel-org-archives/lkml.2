Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933905Ab0DHXlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 19:41:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41670 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933883Ab0DHXlF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 19:41:05 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "=?utf-8?q?J=C3=A9r=C3=B4me=20Glisse?=" <glisse@freedesktop.org>,
       "Markus Trippelsdorf" <markus@trippelsdorf.de>
References: <cjwJ7Pf9h0L.A.9pB.1DmvLB@chimera>
In-Reply-To: <cjwJ7Pf9h0L.A.9pB.1DmvLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <onZ81XwyNTD.A.MbD.rFmvLB@chimera>
Subject: [Bug #15276] latest git kernel: general protection fault: 0000 [#1]
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  9 Apr 2010 01:04:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.32 and 2.6.33.

The following bug entry is on the current list of known regressions
introduced between 2.6.32 and 2.6.33.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15276
Subject		: latest git kernel: general protection fault: 0000 [#1]
Submitter	: Markus Trippelsdorf <markus@trippelsdorf.de>
Date		: 2010-02-09 8:36 (59 days old)
Message-ID	: <20100209083605.GA1766@arch.tripp.de>
References	: http://marc.info/?l=linux-kernel&m=126570498804223&w=2
Handled-By	: Jérôme Glisse <glisse@freedesktop.org>


