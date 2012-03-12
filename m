Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab2CLHAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 03:00:49 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:49229 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab2CLHAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 03:00:43 -0400
Date: Mon, 12 Mar 2012 09:00:40 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #42776] OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
In-Reply-To: <C6gS2DkSgiG.A.T5B._tRXPB@chimera>
Message-ID: <alpine.SOC.1.00.1203120859450.3389@math.ut.ee>
References: <WuYv90FoNpB.A.O8.ktRXPB@chimera> <C6gS2DkSgiG.A.T5B._tRXPB@chimera>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The following bug entry is on the current list of known regressions
> from 3.2.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42776
> Subject		: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
> Submitter	: Meelis Roos <mroos@linux.ee>
> Date		: 2012-02-13 7:45 (28 days old)
> Message-ID	: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee>
> References	: http://marc.info/?l=linux-kernel&m=132911916331615&w=2
> 		  http://marc.info/?l=linux-kernel&m=132993294018762&w=2

Workaround has been merged and this regression is fixed. Deeper cause 
will probably be investigated later.

-- 
Meelis Roos (mroos@linux.ee)
