Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab2DSSQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 14:16:06 -0400
Received: from mail.us.es ([193.147.175.20]:39973 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475Ab2DSSQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:16:03 -0400
Date: Thu, 19 Apr 2012 20:16:00 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Tejun Heo <tj@kernel.org>, Patrick McHardy <kaber@trash.net>,
        Netfilter Development Mailing list 
	<netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH net-next] netfilter: nf_conntrack.h: use this_cpu_inc()
Message-ID: <20120419181600.GA17878@1984>
References: <1334723800.2472.88.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334723800.2472.88.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 06:36:40AM +0200, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> this_cpu_inc() is IRQ safe and faster than
> local_bh_disable()/__this_cpu_inc()/local_bh_enable(), at least on x86.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Patrick McHardy <kaber@trash.net>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Tejun Heo <tj@kernel.org>

Applied, thanks.
