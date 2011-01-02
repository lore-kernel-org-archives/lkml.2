Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1ABUP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 15:15:28 -0500
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:40883 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab1ABUP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 15:15:27 -0500
Date: Sun, 2 Jan 2011 22:15:24 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #16971] qla4xxx compile failure on 32-bit PowerPC: missing
 readq and writeq
In-Reply-To: <LbeBv-BNQpL.A.QKB.MI8GNB@chimera>
Message-ID: <alpine.SOC.1.00.1101022215110.21244@math.ut.ee>
References: <odW4v9b6arG.A.2bH.uE8GNB@chimera> <LbeBv-BNQpL.A.QKB.MI8GNB@chimera>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16971
> Subject		: qla4xxx compile failure on 32-bit PowerPC: missing readq and writeq
> Submitter	: Meelis Roos <mroos@linux.ee>
> Date		: 2010-08-19 21:03 (133 days old)
> Message-ID	: <<<alpine.SOC.1.00.1008192359310.19654@math.ut.ee>>>
> References	: http://marc.info/?l=linux-kernel&m=128225184900892&w=2
> Patch		: http://marc.info/?l=linux-scsi&m=128590267608876&w=2

Still unpatched in mainline.

-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/
