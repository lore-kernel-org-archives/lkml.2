Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab1CLWfi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 17:35:38 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:36533 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754912Ab1CLWfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 17:35:36 -0500
X-Greylist: delayed 1426 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Mar 2011 17:35:36 EST
Date: Sun, 13 Mar 2011 00:11:49 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #28452] 2.6.38-rc3 regression on parisc: segfaults
In-Reply-To: <8H3lez1sawF.A.-DH.cAxVNB@chimera>
Message-ID: <alpine.SOC.1.00.1103130009230.6027@math.ut.ee>
References: <NMZS1i37KEE.A.1eG.6_wVNB@chimera> <8H3lez1sawF.A.-DH.cAxVNB@chimera>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28452
> Subject		: 2.6.38-rc3 regression on parisc: segfaults

Can not currently test. I regained access to that remote machine but 
trying to upgrade to latest tools + source has broken several other 
things for me (udev worked around manually and binutils refusing to 
assemble pacache.S). Will try the lastest 2.6.38-rc8+git ASAP when I get 
it to work otherwise.

-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/
