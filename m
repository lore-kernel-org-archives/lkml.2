Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab1IPJYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 05:24:40 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:21593 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1IPJYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 05:24:38 -0400
Date: Fri, 16 Sep 2011 05:24:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>, Jan Beulich <JBeulich@suse.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: xen/blkback: Add support for old BARRIER requests -
 'feature-barrier', was "Help with implementing some form of barriers in 3.0
 kernels."
Message-ID: <20110916092416.GA2003@phenom.oracle.com>
References: <20110914085913.GB25628@phenom.oracle.com>
 <4E708C240200007800055FDF@nat28.tlf.novell.com>
 <20110914143247.GA17206@phenom.oracle.com>
 <20110914150102.GA18015@phenom.oracle.com>
 <4E70EEB302000078000561AE@nat28.tlf.novell.com>
 <20110915125111.GA18875@phenom.oracle.com>
 <4E72131B02000078000564AC@nat28.tlf.novell.com>
 <20110915142125.GB19897@phenom.oracle.com>
 <20110915151326.GA16195@quack.suse.cz>
 <20110915151540.GA24348@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110915151540.GA24348@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4E7315CC.00DA,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 11:15:40AM -0400, Christoph Hellwig wrote:
> Btw, I'm really against exporting any of the low-level request/elevator
> code interfaces.  I have plans for huge changes in that area, and having
> someone poke into it is just a bad idea.

Thanks for the heads up.
> 
> Try to take a look at the barrier era dm implementation of them, which
> did the draining on the bio layer and copy & paste that.

Jan (K), do you want to poke at that and re-use the patch of yours which I
have been altering?
