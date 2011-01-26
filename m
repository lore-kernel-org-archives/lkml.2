Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab1AZAr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 19:47:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46872 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab1AZAr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 19:47:56 -0500
Date: Tue, 25 Jan 2011 19:47:41 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>, akpm@linux-foundation.org,
        hannes@cmpxchg.org, ryomov@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: (not so much) Fun with THP
Message-ID: <20110126004741.GS27353@bombadil.infradead.org>
References: <0d30dc$krvjbc@orsmga001.jf.intel.com>
 <20110125175706.GE926@random.random>
 <1bdc18$jcs0b0@fmsmga002.fm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bdc18$jcs0b0@fmsmga002.fm.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 06:52:55PM +0000, Chris Wilson wrote:
> On Tue, 25 Jan 2011 18:57:06 +0100, Andrea Arcangeli <aarcange@redhat.com> wrote:
> > On Tue, Jan 25, 2011 at 03:58:30PM +0000, Chris Wilson wrote:
> > > On the one F15 box I've dared enable THP with, it hasn't succeeded in
> > > booting (with or without KMS).  First it OOMed during lvm:
> > 
> > Sorry, for x86_32 there was some issue, below is all you need, thanks!
> 
> Thank you, I was missing the paravirt patch.

Thanks Chris, Andrea,

That explains a bug I've had users seeing which I cannot reproduce
(since I'm all on 64-bit...)

regards,
--Kyle
