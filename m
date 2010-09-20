Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab0ITUVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:21:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52093 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594Ab0ITUVF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:21:05 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "H. Peter Anvin" <hpa@zytor.com>, "Nix" <nix@esperi.org.uk>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Venkatesh Pallipadi" <venki@google.com>
References: <r2gGqgg1zFC.A.LrE.w97lMB@chimera>
In-Reply-To: <r2gGqgg1zFC.A.LrE.w97lMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <aRnAGz9xZ8K.A.lAF.897lMB@chimera>
Subject: [Bug #18272] 2.6.35.*: horrible (exponential? >linear) slowdown to unusability (ACPI idle?)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 20 Sep 2010 21:57:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.34 and 2.6.35.

The following bug entry is on the current list of known regressions
introduced between 2.6.34 and 2.6.35.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=18272
Subject		: 2.6.35.*: horrible (exponential? >linear) slowdown to unusability (ACPI idle?)
Submitter	: Nix <nix@esperi.org.uk>
Date		: 2010-09-05 0:51 (16 days old)
First-Bad-Commit: http://git.kernel.org/linus/30a564be9d9554c168a654eddc2165869cc0d7bf
Message-ID	: <87zkvx2ese.fsf@spindle.srvr.nix>
References	: http://marc.info/?l=linux-kernel&m=128364994602942&w=2


