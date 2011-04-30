Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1D3TqK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 15:46:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38709 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab1D3TqF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 15:46:05 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Bart Van Assche" <bart.vanassche@gmail.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
References: <Xp4OiTz83N.A.O0D.JVGvNB@chimera>
In-Reply-To: <Xp4OiTz83N.A.O0D.JVGvNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <G9uL1cldhmL.A.sNF.dWGvNB@chimera>
Subject: [Bug #32982] Kernel locks up a few minutes after boot
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 Apr 2011 21:42:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.38.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=32982
Subject		: Kernel locks up a few minutes after boot
Submitter	: Bart Van Assche <bart.vanassche@gmail.com>
Date		: 2011-04-10 19:55 (21 days old)


