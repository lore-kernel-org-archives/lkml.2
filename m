Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab0LEVAc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 16:00:32 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:40316 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901Ab0LEVAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 16:00:31 -0500
Date: Sun, 5 Dec 2010 23:00:29 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #16971] qla4xxx compile failure on 32-bit PowerPC: missing
 readq and writeq
In-Reply-To: <z3LGq_ncuOB.A.aSG.eD_-MB@chimera>
Message-ID: <alpine.SOC.1.00.1012052300100.18105@math.ut.ee>
References: <jyQ21do2hOF.A.qwD.m_--MB@chimera> <z3LGq_ncuOB.A.aSG.eD_-MB@chimera>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The following bug entry is on the current list of known regressions
> introduced between 2.6.35 and 2.6.36.  Please verify if it still should
> be listed and let the tracking team know (either way).

Yes, still present in yesterdays git.

-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/
