Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab0IKAOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 20:14:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48147 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab0IKAN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 20:13:59 -0400
Date: Fri, 10 Sep 2010 20:13:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: florian@mickler.org, Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        "Wolfram Sang (role:commit_signer)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100911001350.GA11478@infradead.org>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
 <1284111767.1783.35.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284111767.1783.35.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 02:42:47AM -0700, Joe Perches wrote:
> I don't like reading annotated email names myself.
> 
> As the coverage of file patterns in MAINTAINERS is
> now pretty good, the --git results are less useful.
> 
> I'd much rather turn off --git as a default, or change
> get_maintainers to add git signers only when there's no
> specifically listed maintainer for a particular file.

Whoever made --git the default was on crack and this needs to be
reverted ASAP.  Just because people do global API changes it doesn't
mean they need to be cced on every second pathc to the kernel tree.

We already have a mailinglist for that purpose.

