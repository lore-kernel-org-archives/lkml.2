Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab1JROWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 10:22:10 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33381
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755256Ab1JROWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 10:22:08 -0400
Date: Tue, 18 Oct 2011 10:22:05 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Christoph Hellwig <hch@infradead.org>, Josh Boyer <jwboyer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] Update email address for stable patch submission
Message-ID: <20111018142204.GA14341@infradead.org>
References: <20111018011638.GQ1165@zod.bos.redhat.com>
 <20111018065852.GA6056@infradead.org>
 <20111018141350.GB17101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111018141350.GB17101@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 07:13:50AM -0700, Greg KH wrote:
> On Tue, Oct 18, 2011 at 02:58:52AM -0400, Christoph Hellwig wrote:
> > On Mon, Oct 17, 2011 at 09:16:39PM -0400, Josh Boyer wrote:
> > > The stable@kernel.org email address has been replaced with the
> > > stable@vger.kernel.org mailing list.  Change the stable kernel rules to
> > > reference the new list instead of the semi-defunct email alias.
> > 
> > Does this mean it already stopped working?  I recently sent pathces
> > there but neither got an ACK nor a bounce or similar.
> 
> It should have bounced.
> 
> But, if you put a "Cc: stable@kernel.org" in the patch, I'm still
> picking that up properly when it goes to Linus's tree.

Doesn't help if two of the patch have been for a while, and the
others need various small updates to apply against 3.0 (file renames
and macro removal)
