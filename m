Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab2LDMN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 07:13:57 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:40016 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab2LDMN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 07:13:56 -0500
Date: Tue, 4 Dec 2012 14:13:53 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Jens Axboe <axboe@kernel.dk>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression in 3.7-rc8: block device size
In-Reply-To: <50BDE44F.9070001@kernel.dk>
Message-ID: <alpine.SOC.1.00.1212041412330.28067@math.ut.ee>
References: <alpine.SOC.1.00.1212041126440.20927@math.ut.ee> <50BDE44F.9070001@kernel.dk>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Most likely Linus' shuffle of code in there. For ease of debugging, can
> you a bisect of fs/ between rc7 and rc8? Just do;

Already found the discussion and patch in 3.7-rc8 thread. Linus's patch 
worked fine for me too.

-- 
Meelis Roos (mroos@linux.ee)
