Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab0IVIuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 04:50:07 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:37144 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab0IVIuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 04:50:06 -0400
Date: Wed, 22 Sep 2010 11:50:03 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #16971] qla4xxx compile failure on 32-bit PowerPC: missing
 readq and writeq
In-Reply-To: <Wn2eLj_6KZG.A.SpH.KF7lMB@chimera>
Message-ID: <alpine.SOC.1.00.1009221148550.14750@math.ut.ee>
References: <1fwtoy8sG5H.A.veG.9D7lMB@chimera> <Wn2eLj_6KZG.A.SpH.KF7lMB@chimera>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16971
> Subject		: qla4xxx compile failure on 32-bit PowerPC: missing readq and writeq
> Submitter	: Meelis Roos <mroos@linux.ee>
> Date		: 2010-08-19 21:03 (33 days old)
> Message-ID	: <alpine.SOC.1.00.1008192359310.19654@math.ut.ee>
> References	: http://marc.info/?l=linux-kernel&m=128225184900892&w=2

Still present. The maintainer of the driver has a patch that I have 
tested, and for quite some time now, but it still does not appear in 
mainline.

-- 
Meelis Roos (mroos@linux.ee)
