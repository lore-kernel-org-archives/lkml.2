Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab2LDMPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 07:15:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53301 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab2LDMO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 07:14:59 -0500
Message-ID: <50BDE93C.4050704@kernel.dk>
Date: Tue, 04 Dec 2012 13:14:52 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression in 3.7-rc8: block device size
References: <alpine.SOC.1.00.1212041126440.20927@math.ut.ee> <50BDE44F.9070001@kernel.dk> <alpine.SOC.1.00.1212041412330.28067@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.1212041412330.28067@math.ut.ee>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-04 13:13, Meelis Roos wrote:
>> Most likely Linus' shuffle of code in there. For ease of debugging, can
>> you a bisect of fs/ between rc7 and rc8? Just do;
> 
> Already found the discussion and patch in 3.7-rc8 thread. Linus's patch 
> worked fine for me too.

Even better! Thanks.

-- 
Jens Axboe

