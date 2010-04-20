Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab0DTD77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 23:59:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48713 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626Ab0DTD7x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 23:59:53 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rabin Vincent" <rabin@rab.in>,
       "Yinghai Lu" <yinghai@kernel.org>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
In-Reply-To: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <YeFfFNFyTSF.A.sj.BSSzLB@tosh>
Subject: [Bug #15668] start_kernel(): bug: interrupts were enabled early
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 20 Apr 2010 05:19:21 +0200 (CEST)
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
Date		: 2010-03-25 19:53 (26 days old)
First-Bad-Commit: http://kernel.org/git/linus/773e3eb7b81e5ba13b5155dfb3bb75b8ce37f8f9
Message-ID	: <20100325194100.GA2364@debian>
References	: http://marc.info/?l=linux-kernel&m=126954607216519&w=2


