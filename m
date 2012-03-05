Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab2CEH0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 02:26:07 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:59624 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab2CEH0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 02:26:05 -0500
Date: Mon, 5 Mar 2012 09:26:01 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #42776] OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
In-Reply-To: <hq7dqombK_C.A.M0E.KG9UPB@chimera>
Message-ID: <alpine.SOC.1.00.1203050925000.22265@math.ut.ee>
References: <FNlNbnGKWLP.A.dME.3F9UPB@chimera> <hq7dqombK_C.A.M0E.KG9UPB@chimera>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42776
> Subject		: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
> Submitter	: Meelis Roos <mroos@linux.ee>
> Date		: 2012-02-13 7:45 (21 days old)
> Message-ID	: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee>
> References	: http://marc.info/?l=linux-kernel&m=132911916331615&w=2
> 		  http://marc.info/?l=linux-kernel&m=132993294018762&w=2

Works in 3.3-rc6. The patch is like a workaround if understand correctly 
but it cures the problem.

-- 
Meelis Roos (mroos@linux.ee)
