Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab0KFAdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 20:33:12 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:61337 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754216Ab0KFAdK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 20:33:10 -0400
X-AuditID: 1209190e-b7b3bae000000a71-e2-4cd4a245b5a1
Subject: Re: BUG in ext4 with 2.6.37-rc1
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <1288998589.2961.3.camel@localhost>
Date: Fri, 5 Nov 2010 20:33:05 -0400
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <0C557864-9D5C-45A3-8DDF-114E4DD22258@mit.edu>
References: <20101102202013.GA3861@elliptictech.com> <1288998589.2961.3.camel@localhost>
To: Tony Vroon <tony@linx.net>
X-Mailer: Apple Mail (2.1081)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 5, 2010, at 7:09 PM, Tony Vroon wrote:

> On Tue, 2010-11-02 at 16:20 -0400, Nick Bowler wrote:
>>  ------------[ cut here ]------------
>>  kernel BUG at /scratch_space/linux-2.6/fs/ext4/page-io.c:146!
>>  invalid opcode: 0000 [#1] PREEMPT SMP 
> 
> Confirmed, it's an issue here too.
> I have just hit this one 2 times in a row within 20 minutes. Please CC
> me if you need any fix tested; looks like I'm off to 2.6.26 until this
> is fixed.
> 

Hi, my apologies for not having a lot of time to look at this.  I've been at the Linux Plumber's Conference and Kernel Summit this whole week.

What did you have running which triggered this, and can you try the patch that I sent in this patch, and see if you get the same other BUG_ON?   And if you have the stack trace easily to hand, it would be useful to make sure that part is the same as well.

Many thanks,

-- Ted

