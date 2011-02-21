Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab1BUWqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 17:46:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45311 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002Ab1BUWoZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 17:44:25 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Keith Packard" <keithp@keithp.com>, "Takashi Iwai" <tiwai@suse.de>
References: <JwKd6rET8XO.A._ZC.gbuYNB@chimera>
In-Reply-To: <JwKd6rET8XO.A._ZC.gbuYNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <f14qsMvj2tF.A.VRE.6duYNB@chimera>
Subject: [Bug #24982] Inconsistent DPMS handling with 2.6.37 DRM
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 21 Feb 2011 23:37:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.36 and 2.6.37.

The following bug entry is on the current list of known regressions
introduced between 2.6.36 and 2.6.37.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24982
Subject		: Inconsistent DPMS handling with 2.6.37 DRM
Submitter	: Takashi Iwai <tiwai@suse.de>
Date		: 2010-12-16 16:32 (68 days old)
Handled-By	: Takashi Iwai <tiwai@suse.de>
		  Keith Packard <keithp@keithp.com>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=40392
		  https://patchwork.kernel.org/patch/530921/


