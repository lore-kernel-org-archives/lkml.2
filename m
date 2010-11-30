Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab0K3RxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:53:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34080 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab0K3RxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:53:24 -0500
Date: Tue, 30 Nov 2010 12:53:17 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Tejun Heo <tj@kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 2.6.37
Message-ID: <20101130175317.GB25668@bombadil.infradead.org>
References: <20101022012302.GA7487@havoc.gtf.org>
 <20101129180755.GK15818@bombadil.infradead.org>
 <4CF506A6.4020200@kernel.org>
 <20101130153839.GM15818@bombadil.infradead.org>
 <4CF52652.4030802@kernel.org>
 <20101130163150.GA25668@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130163150.GA25668@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 11:31:50AM -0500, Kyle McMartin wrote:
> On Tue, Nov 30, 2010 at 05:29:06PM +0100, Tejun Heo wrote:
> > > Be happy to apply any debug patches, but I plan on replacing the drive
> > > with a faster one at some point in the next few weeks.
> > 
> > Can you please apply the following patch and report the resulting
> > kernel log?  You're on ahci, right?
> > 
> 
> Yup, building now.
> 

Ok, running it, I haven't seen the issue across three suspends... Will
update when it inevitably happens.

--Kyle
