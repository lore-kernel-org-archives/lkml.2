Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab0H3IqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 04:46:00 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:60219 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab0H3Ip7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 04:45:59 -0400
Date: Mon, 30 Aug 2010 11:45:56 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #16971] qla4xxx compile failure on 32-bit PowerPC: missing
 readq and writeq
In-Reply-To: <4AUWBNzTkbD.A.aU.BGueMB@chimera>
Message-ID: <alpine.SOC.1.00.1008301145230.29117@math.ut.ee>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera> <4AUWBNzTkbD.A.aU.BGueMB@chimera>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16971
> Subject		: qla4xxx compile failure on 32-bit PowerPC: missing readq and writeq
> Submitter	: Meelis Roos <mroos@linux.ee>
> Date		: 2010-08-19 21:03 (11 days old)
> Message-ID	: <alpine.SOC.1.00.1008192359310.19654@math.ut.ee>
> References	: http://marc.info/?l=linux-kernel&m=128225184900892&w=2

Still present in 2.6.36-rc3.

-- 
Meelis Roos (mroos@linux.ee)
