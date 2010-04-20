Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab0DTECP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 00:02:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48786 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab0DTEBQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 00:01:16 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "=?utf-8?q?=C3=89ric=20Piel?=" <Eric.Piel@tremplin-utc.net>,
       "Jaroslav Kysela" <perex@perex.cz>, "Takashi Iwai" <tiwai@suse.de>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
In-Reply-To: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <YeFfFNFyTSF.A.EXG.IRSzLB@tosh>
Subject: [Bug #15796] [REGRESSION bisected] Sound goes too fast due to commit 7b3a177b0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 20 Apr 2010 05:19:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.33.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15796
Subject		: [REGRESSION bisected] Sound goes too fast due to commit 7b3a177b0
Submitter	: Éric Piel <Eric.Piel@tremplin-utc.net>
Date		: 2010-04-13 21:54 (7 days old)
First-Bad-Commit: http://kernel.org/git/linus/7b3a177b0d4f92b3431b8dca777313a07533a710
Message-ID	: <4BC4E812.6050602@tremplin-utc.net>
References	: http://marc.info/?l=linux-kernel&m=127119569009790&w=2
Handled-By	: Takashi Iwai <tiwai@suse.de>


