Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab0LSMkf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 07:40:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38404 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756170Ab0LSMkc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 07:40:32 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "Brian Rogers" <brian@xyzw.org>,
        "Jeff Mahoney" <jeffm@suse.com>
References: <wNJKqSoEutL.A.lKD.odfDNB@chimera>
In-Reply-To: <wNJKqSoEutL.A.lKD.odfDNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <6Ue85L6pKCJ.A.DUE.YefDNB@chimera>
Subject: [Bug #24272] iotop reports insane per-process disk read/write statistics
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 19 Dec 2010 13:34:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.36.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24272
Subject		: iotop reports insane per-process disk read/write statistics
Submitter	: Brian Rogers <brian@xyzw.org>
Date		: 2010-12-03 12:00 (17 days old)
First-Bad-Commit: http://git.kernel.org/linus/85893120699f8bae8caa12a8ee18ab5fceac978e


