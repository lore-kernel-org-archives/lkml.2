Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab1C1Nom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 09:44:42 -0400
Received: from verein.lst.de ([213.95.11.211]:51487 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939Ab1C1Nol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 09:44:41 -0400
Date: Mon, 28 Mar 2011 15:44:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@lst.de>, David Chinner <david@fromorbit.com>,
        xfs-masters@oss.sgi.com, Jens Axboe <jaxboe@fusionio.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [xfs-masters] linux-next: manual merge of the xfs tree with
	Linus' tree
Message-ID: <20110328134440.GA31780@lst.de>
References: <20110328122148.1b48a742.sfr@canb.auug.org.au> <20110328104753.GA27327@lst.de> <20110329003725.7815c2a3.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110329003725.7815c2a3.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 12:37:25AM +1100, Stephen Rothwell wrote:
> So does that mean that the whole xfs tree commit can be removed/ignored?
> That is a bit of a pain to do in a merge (especially considering that
> there is another commit in the xfs tree that changes that file.  If the
> whole commit is no longer needed, maybe it could be dropped from the xfs
> tree or reverted.

No, that change is just a small part of the commit.
