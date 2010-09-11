Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab0IKAqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 20:46:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58922 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab0IKAp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 20:45:58 -0400
Date: Fri, 10 Sep 2010 20:45:51 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: Christoph Hellwig <hch@infradead.org>, florian@mickler.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        "Wolfram Sang (role:commit_signer)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100911004550.GA30584@infradead.org>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
 <1284111767.1783.35.camel@Joe-Laptop>
 <20100911001350.GA11478@infradead.org>
 <1284165074.1783.213.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284165074.1783.213.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 05:31:14PM -0700, Joe Perches wrote:
> If you don't like it, you could use a .get_maintainer.conf
> file entry until some consensus is reached later.

I don't use the pice of junk at all.  What really pisses me off is that
I get spamed by all by tons of utterly useless cleanups patches (and
some useful but not at all interesting to me patches) because some
idiot made the bloody script return my address just because I touched a
file.  If it goes on like that I'll simply have to add a mail filter to
throw away all patches sent directly to me instead of a mailinglist.

