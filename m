Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab0DGVui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 17:50:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37777 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983Ab0DGVub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 17:50:31 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rabin Vincent" <rabin@rab.in>,
       "Yinghai Lu" <yinghai@kernel.org>
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera>
In-Reply-To: <6Pphclm24fK.A.lSF.qsPvLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <JVS2s9dmTsP.A.4LH.YtPvLB@chimera>
Subject: [Bug #15668] start_kernel(): bug: interrupts were enabled early
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  7 Apr 2010 23:13:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.33.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15668
Subject		: start_kernel(): bug: interrupts were enabled early
Submitter	: Rabin Vincent <rabin@rab.in>
Date		: 2010-03-25 19:53 (14 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/773e3eb7b81e5ba13b5155dfb3bb75b8ce37f8f9
Message-ID	: <20100325194100.GA2364@debian>
References	: http://marc.info/?l=linux-kernel&m=126954607216519&w=2


