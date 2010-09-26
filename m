Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab0IZU7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 16:59:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43084 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234Ab0IZU7C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 16:59:02 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Sander Eikelenboom" <linux@eikelenboom.it>
References: <onxdOCF6lb.A.vKB.a_6nMB@chimera>
In-Reply-To: <onxdOCF6lb.A.vKB.a_6nMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <UfOptYFtL6C.A.NjC.4A7nMB@chimera>
Subject: [Bug #16614] [2.6.35] usb 2.0 em28xx  kernel panic general protection fault: 0000 [#1] SMP          RIP: 0010:[<ffffffffa004fbc5>]  [<ffffffffa004fbc5>] em28xx_isoc_copy_vbi+0x62e/0x812 [em28xx]
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Sep 2010 22:33:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.34 and 2.6.35.

The following bug entry is on the current list of known regressions
introduced between 2.6.34 and 2.6.35.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16614
Subject		: [2.6.35] usb 2.0 em28xx  kernel panic general protection fault: 0000 [#1] SMP          RIP: 0010:[<ffffffffa004fbc5>]  [<ffffffffa004fbc5>] em28xx_isoc_copy_vbi+0x62e/0x812 [em28xx]
Submitter	: Sander Eikelenboom <linux@eikelenboom.it>
Date		: 2010-08-10 22:12 (48 days old)
Message-ID	: <61936849.20100811001257@eikelenboom.it>
References	: http://marc.info/?l=linux-kernel&m=128152075830927&w=2


