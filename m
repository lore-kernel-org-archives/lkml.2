Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901Ab0GWLwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 07:52:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51657 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756980Ab0GWLwE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 07:52:04 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "=?utf-8?q?Ortwin=20Gl=C3=BCck?=" <odi@odi.ch>
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
In-Reply-To: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <tneGvaw1wLL.A.IN.n2XSMB@chimera>
Subject: [Bug #16392] BUG at arch/x86/mm/physaddr.c:5
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 23 Jul 2010 13:47:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16392
Subject		: BUG at arch/x86/mm/physaddr.c:5
Submitter	: Ortwin Glück <odi@odi.ch>
Date		: 2010-07-14 6:54 (10 days old)
Message-ID	: <4C3D5F3F.7070901@odi.ch>
References	: http://marc.info/?l=linux-kernel&m=127909052705341&w=2


