Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab0JVI4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:56:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49540 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab0JVI43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:56:29 -0400
Date: Fri, 22 Oct 2010 04:56:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>
Subject: Re: linux-next regression: IO errors in with ext4 and xen-blkfront
Message-ID: <20101022085624.GA5672@infradead.org>
References: <4CBF83A0.8090802@goop.org>
 <4CBF84C9.6050606@goop.org>
 <4CC148E5.2030605@kernel.dk>
 <20101022082916.GA14070@infradead.org>
 <4CC1515E.6080006@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC1515E.6080006@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 10:54:54AM +0200, Jens Axboe wrote:
> So how about we just disable barriers for Xen atm? I would really really
> like to push that branch out as well now, since I'll be travelling for
> most of the merge window this time.

Yes, that's what removing/commenting out that line does.

