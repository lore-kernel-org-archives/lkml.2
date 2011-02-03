Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab1BCAM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:12:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38468 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755762Ab1BCAGf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:06:35 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "=?utf-8?q?David=20H=C3=A4rdeman?=" <david@hardeman.nu>,
        "=?utf-8?q?T=C3=B5nu=20Raitviir?=" <jussuf@linux.ee>
References: <e9vOd5LzdBK.A.dyD.h6eSNB@chimera>
In-Reply-To: <e9vOd5LzdBK.A.dyD.h6eSNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <-tcJxClTQPH.A.EFF.P8eSNB@chimera>
Subject: [Bug #25732] i915 turns picture green when display switched off-on
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu,  3 Feb 2011 01:05:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.36 and 2.6.37.

The following bug entry is on the current list of known regressions
introduced between 2.6.36 and 2.6.37.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=25732
Subject		: i915 turns picture green when display switched off-on
Submitter	: Tõnu Raitviir <jussuf@linux.ee>
Date		: 2010-12-27 22:14 (38 days old)
First-Bad-Commit: http://git.kernel.org/linus/3c17fe4b8f40a112a85758a9ab2aebf772bdd647
Handled-By	: Chris Wilson <chris@chris-wilson.co.uk>


