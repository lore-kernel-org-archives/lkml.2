Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab1FZXAi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 19:00:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59669 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457Ab1FZW6L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 18:58:11 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Arno Wagner" <arno@wagner.name>
References: <fvHbBUhG0PD.A.IGE.HM7BOB@chimera>
In-Reply-To: <fvHbBUhG0PD.A.IGE.HM7BOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Rm1pgFxEGUF.A.k4E.MN7BOB@chimera>
Subject: [Bug #36092] Filesystem lockup on USB HDD plug-in
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 27 Jun 2011 00:35:11 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.38 and 2.6.39.

The following bug entry is on the current list of known regressions
introduced between 2.6.38 and 2.6.39.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36092
Subject		: Filesystem lockup on USB HDD plug-in
Submitter	: Arno Wagner <arno@wagner.name>
Date		: 2011-05-28 12:34 (30 days old)


