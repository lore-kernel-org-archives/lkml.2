Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab1DSLbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 07:31:01 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:58710 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab1DSLbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 07:31:00 -0400
Date: Tue, 19 Apr 2011 14:30:58 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #28452] 2.6.38-rc3 regression on parisc: segfaults
In-Reply-To: <IqJL5EkbqD.A.MRG.c6uqNB@chimera>
Message-ID: <alpine.SOC.1.00.1104191427470.1402@math.ut.ee>
References: <sam8u5dLkaB.A.afE.53uqNB@chimera> <IqJL5EkbqD.A.MRG.c6uqNB@chimera>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28452
> Subject		: 2.6.38-rc3 regression on parisc: segfaults
> Submitter	: Meelis Roos <mroos@linux.ee>
> Date		: 2011-02-01 22:00 (76 days old)
> Message-ID	: <alpine.SOC.1.00.1102012342200.25944@math.ut.ee>
> References	: http://marc.info/?l=linux-kernel&m=129659763426600&w=2

Tried 2.6.39-rc4, still got segfault from aptitude update (but not 
easily reproducible), updated bugzilla.

-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/
