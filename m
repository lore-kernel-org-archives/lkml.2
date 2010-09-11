Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105Ab0IKJ26 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 05:28:58 -0400
Received: from ist.d-labs.de ([213.239.218.44]:49153 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab0IKJ25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 05:28:57 -0400
Date: Sat, 11 Sep 2010 11:28:55 +0200
From: Florian Mickler <florian@mickler.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        "Wolfram Sang (role:commit_signer)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100911112855.6ee6e929@schatten.dmk.lab>
In-Reply-To: <20100911004550.GA30584@infradead.org>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	<1284111767.1783.35.camel@Joe-Laptop>
	<20100911001350.GA11478@infradead.org>
	<1284165074.1783.213.camel@Joe-Laptop>
	<20100911004550.GA30584@infradead.org>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Sep 2010 20:45:51 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Sep 10, 2010 at 05:31:14PM -0700, Joe Perches wrote:
> > If you don't like it, you could use a .get_maintainer.conf
> > file entry until some consensus is reached later.
> 
> I don't use the pice of junk at all.  What really pisses me off is that
> I get spamed by all by tons of utterly useless cleanups patches (and
> some useful but not at all interesting to me patches) because some
> idiot made the bloody script return my address just because I touched a
> file.  If it goes on like that I'll simply have to add a mail filter to
> throw away all patches sent directly to me instead of a mailinglist.
> 

But would you also have the same attitude towards these specific
'spams' if it were made clear in the email adress field that you were
cc'd as a commit_signer  (vs maintainer)?

I know it is a bit hackisch to have stuff in the name field, but it is
rfc conform, it is even proposed for redirected email '(by way of...)'. 

Cheers,
Flo
