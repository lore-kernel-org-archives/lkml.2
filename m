Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab0KSKL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 05:11:27 -0500
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:45370 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab0KSKLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 05:11:25 -0500
X-Greylist: delayed 1998 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2010 05:11:25 EST
Date: Fri, 19 Nov 2010 11:38:04 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #16971] qla4xxx compile failure on 32-bit PowerPC: missing
 readq and writeq
In-Reply-To: <t78YtCSuOqN.A.AJ.q6b5MB@chimera>
Message-ID: <alpine.SOC.1.00.1011191106540.26731@math.ut.ee>
References: <tTUH_XeInOH.A.dMF.c3b5MB@chimera> <t78YtCSuOqN.A.AJ.q6b5MB@chimera>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16971
> Subject		: qla4xxx compile failure on 32-bit PowerPC: missing readq and writeq
> Submitter	: Meelis Roos <mroos@linux.ee>
> Date		: 2010-08-19 21:03 (92 days old)
> Message-ID	: <<alpine.SOC.1.00.1008192359310.19654@math.ut.ee>>
> References	: http://marc.info/?l=linux-kernel&m=128225184900892&w=2

Still unfixed in mainline.

-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/
