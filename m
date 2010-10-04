Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab0JDRqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 13:46:22 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:33592 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab0JDRqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 13:46:21 -0400
Message-ID: <4CAA12F2.10405@kernel.dk>
Date: Mon, 04 Oct 2010 19:46:26 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: Re: [Bug #19062] Dirtiable inode bdi default != sb bdi btrfs
References: <MEG5YPP-fxC.A.vnD.So6nMB@chimera> <sQALkqF1FWE.A.15D.bo6nMB@chimera> <20101002165433.GL21129@thunk.org> <201010022358.35972.rjw@sisk.pl> <20101003022707.GN21129@thunk.org> <4CA89E63.4080907@kernel.org> <20101004095943.GE3589@quack.suse.cz> <20101004101212.GA25617@infradead.org>
In-Reply-To: <20101004101212.GA25617@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-04 12:12, Christoph Hellwig wrote:
> On Mon, Oct 04, 2010 at 11:59:44AM +0200, Jan Kara wrote:
>>   Yes, it's caused by one of my fixes. It's harmless (the warning I've
>> added is just too strict). Christoph has a patch that also fixes this
>> - http://lkml.org/lkml/2010/9/29/76. I hope he'll push it soon.
> 
> Jens is the writeback maintainer, so he will have to pick it up.

It's in, will push it asap.

-- 
Jens Axboe

