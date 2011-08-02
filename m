Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab1HBImU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 04:42:20 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:35118 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab1HBImO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 04:42:14 -0400
X-ASG-Debug-ID: 1312274532-03d6a510a92248c0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E37B863.4080700@fusionio.com>
Date: Tue, 2 Aug 2011 10:42:11 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: linux-next: build warning after merge of the moduleh tree
References: <20110801132359.1de051cb8a4a2bdfdad7560c@canb.auug.org.au> <4E37A696.2090007@fusionio.com> <20110802183558.fda9e3b1e9f3b93a70f6e494@canb.auug.org.au>
X-ASG-Orig-Subj: Re: linux-next: build warning after merge of the moduleh tree
In-Reply-To: <20110802183558.fda9e3b1e9f3b93a70f6e494@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1312274532
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.70672
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-02 10:35, Stephen Rothwell wrote:
> Hi Jens,
> 
> On Tue, 2 Aug 2011 09:26:14 +0200 Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>> Thanks, will you carry this until things are merged? Not easy for me to
>> fix up.
> 
> Yes, no problem.  It is possible that the module.h split may not even go
> into v3.1, in which case the fix patch will jst become part of the moduleh
> tree after the block tree is merged.
> 
> Though the feedback to the original patch writer is that they should have
> included module.h instead of relying on it being implicitly included.

That would arguably have been a much saner approach.

> You could include a patch to add an include of module.h to this file in
> your tree - that way even if the module.h split goes ahead, your tree
> won't get broken.  It could then be changed to the lighter weight
> export.h later.

OK, I will add that. Thanks.

-- 
Jens Axboe

