Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab0LAPuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 10:50:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47675 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab0LAPue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 10:50:34 -0500
Date: Wed, 1 Dec 2010 10:50:26 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Tejun Heo <tj@kernel.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 2.6.37
Message-ID: <20101201155026.GH25668@bombadil.infradead.org>
References: <20101129180755.GK15818@bombadil.infradead.org>
 <4CF506A6.4020200@kernel.org>
 <20101130153839.GM15818@bombadil.infradead.org>
 <4CF52652.4030802@kernel.org>
 <20101130163150.GA25668@bombadil.infradead.org>
 <20101130175317.GB25668@bombadil.infradead.org>
 <20101130210938.GF25668@bombadil.infradead.org>
 <4CF62EE0.7040607@kernel.org>
 <20101201124445.GG25668@bombadil.infradead.org>
 <4CF6595A.6010104@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF6595A.6010104@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 03:19:06PM +0100, Tejun Heo wrote:
> Hello, again.
> 
> On 12/01/2010 01:44 PM, Kyle McMartin wrote:
> > 00:1f.2 SATA controller [0106]: Intel Corporation 5 Series/3400 Series
> ...
> > 	Model Number:       HITACHI HTS725032A9A364                 
> 
> Nothing peculiar.  Hmm... okay, I think I've found what went wrong.
> Can you please try the following patch and see whether the problem
> goes away?
> 

Thanks, I'll let you know when/if it drops to 1.5gbps.

--Kyle
