Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab2CKV4D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 17:56:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38388 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606Ab2CKVyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 17:54:39 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Michael Cree" <mcree@orcon.net.nz>,
        "Michel Lespinasse" <walken@google.com>
References: <WuYv90FoNpB.A.O8.ktRXPB@chimera>
In-Reply-To: <WuYv90FoNpB.A.O8.ktRXPB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <C6gS2DkSgiG.A.AyB.6tRXPB@chimera>
Subject: [Bug #42821] alpha: futex regression bisected
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 Mar 2012 22:31:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 3.2.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42821
Subject		: alpha: futex regression bisected
Submitter	: Michael Cree <mcree@orcon.net.nz>
Date		: 2012-02-20 8:20 (21 days old)
First-Bad-Commit: http://git.kernel.org/linus/8d7718aa082aaf30a0b4989e1f04858952f941bc
Message-ID	: <4F420256.2090600@orcon.net.nz>
References	: http://marc.info/?l=linux-kernel&m=132972606917069&w=2


