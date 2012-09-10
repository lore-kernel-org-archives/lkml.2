Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab2IJU4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 16:56:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab2IJU4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 16:56:14 -0400
Date: Mon, 10 Sep 2012 16:56:06 -0400
From: Jason Baron <jbaron@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jim Cromie <jim.cromie@gmail.com>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] dev_<level> and dynamic_debug cleanups
Message-ID: <20120910205605.GB2406@redhat.com>
References: <cover.1345978012.git.joe@perches.com>
 <20120906175158.GB9786@redhat.com>
 <1346957026.13424.5.camel@joe2Laptop>
 <20120907145235.GA18673@redhat.com>
 <1347030721.13424.22.camel@joe2Laptop>
 <20120907153542.GB18673@redhat.com>
 <1347069350.13424.28.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347069350.13424.28.camel@joe2Laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 06:55:50PM -0700, Joe Perches wrote:
> On Fri, 2012-09-07 at 11:35 -0400, Jason Baron wrote:
> > If nobody else thinks this patch is better, let's at least add a comment in
> > __dev_printk() and __netdev_printk() to fix dynamic debug, if these are changed.
> 
> Or maybe make dynamic_emit_prefix a public function
> and move the __dynamic_<foo>_printk functions to
> nearby the __<foo>_printk functions so it's easier to
> see that changing one requires the other to change.
> 

ok, that makes sense to me.

Thanks,

-Jason

