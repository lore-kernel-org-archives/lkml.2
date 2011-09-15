Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035Ab1IOPQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:16:12 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45402
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756395Ab1IOPQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:16:10 -0400
Date: Thu, 15 Sep 2011 11:15:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@suse.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        hch@infradead.org, axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: xen/blkback: Add support for old BARRIER requests -
 'feature-barrier', was "Help with implementing some form of barriers in 3.0
 kernels."
Message-ID: <20110915151540.GA24348@infradead.org>
References: <4E6F50170200007800055CF5@nat28.tlf.novell.com>
 <20110914085913.GB25628@phenom.oracle.com>
 <4E708C240200007800055FDF@nat28.tlf.novell.com>
 <20110914143247.GA17206@phenom.oracle.com>
 <20110914150102.GA18015@phenom.oracle.com>
 <4E70EEB302000078000561AE@nat28.tlf.novell.com>
 <20110915125111.GA18875@phenom.oracle.com>
 <4E72131B02000078000564AC@nat28.tlf.novell.com>
 <20110915142125.GB19897@phenom.oracle.com>
 <20110915151326.GA16195@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110915151326.GA16195@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, I'm really against exporting any of the low-level request/elevator
code interfaces.  I have plans for huge changes in that area, and having
someone poke into it is just a bad idea.

Try to take a look at the barrier era dm implementation of them, which
did the draining on the bio layer and copy & paste that.

