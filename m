Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab1G2Kgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 06:36:42 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46361
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756115Ab1G2Kgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 06:36:40 -0400
Date: Fri, 29 Jul 2011 06:36:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Greg Banks <gnb@fastmail.fm>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, NeilBrown <neilb@suse.de>,
        linux-nfs@vger.kernel.org, David Miller <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: Fw: [PATCH] sunrpc: use better NUMA affinities
Message-ID: <20110729103634.GA12050@infradead.org>
References: <20110729153207.17af3085@notabene.brown>
 <4E324DB4.7060600@fastmail.fm>
 <1311921035.7845.10.camel@edumazet-laptop>
 <4E3258E1.6020000@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3258E1.6020000@fastmail.fm>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 04:53:21PM +1000, Greg Banks wrote:
> >Check commit 94dcf29a11b3d20a (kthread: use kthread_create_on_node()) to
> >see how this strategy already was adopted for ksoftirqd, kworker,
> >migration, and pktgend kthreads.
> 
> Ah, I see.  It's unfortunate that the kthread_create() API ends up
> being passed a CPU number but that's only used to format the name
> and not for sensible things :(

kthread_create doesn't have a cpu argument - it has a printf-like format
string.

