Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab0IKAbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 20:31:17 -0400
Received: from mail.perches.com ([173.55.12.10]:1658 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537Ab0IKAbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 20:31:16 -0400
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
From: Joe Perches <joe@perches.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: florian@mickler.org, Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        "Wolfram Sang (role:commit_signer)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100911001350.GA11478@infradead.org>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	 <1284111767.1783.35.camel@Joe-Laptop>
	 <20100911001350.GA11478@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Sep 2010 17:31:14 -0700
Message-ID: <1284165074.1783.213.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 20:13 -0400, Christoph Hellwig wrote:
> Whoever made --git the default was on crack and this needs to be
> reverted ASAP.

That'd be Linus' suggestion and it's been the default
for get_maintainers since it was developed.

Reverted? no.
Changed, maybe.

I hardly use the --git option and I do many tree-wide changes.

If you don't like it, you could use a .get_maintainer.conf
file entry until some consensus is reached later.

