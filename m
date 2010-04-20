Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab0DTEDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 00:03:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48741 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab0DTEAc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 00:00:32 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Borislav Petkov" <bp@alien8.de>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
In-Reply-To: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <YeFfFNFyTSF.A.K_G.dRSzLB@tosh>
Subject: [Bug #15730] Ugly rmap NULL ptr deref oopsie on hibernate (was Linux 2.6.34-rc3)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 20 Apr 2010 05:19:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.33.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15730
Subject		: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux 2.6.34-rc3)
Submitter	: Borislav Petkov <bp@alien8.de>
Date		: 2010-04-02 17:59 (18 days old)
Message-ID	: <20100402175937.GA19690@liondog.tnic>
References	: http://marc.info/?l=linux-kernel&m=127023173329741&w=2


