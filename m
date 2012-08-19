Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab2HSPzQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 11:55:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47768 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab2HSPzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 11:55:14 -0400
Subject: Re: IPv4 BUG: held lock freed!
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
Cc: Fengguang Wu <fengguang.wu@intel.com>, David Miller <davem@davemloft.net>,
        networking <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CAF1ivSZK8Y2XpjUXVpNg=m=bs7bGCYqF0ZQU2u_YpEUrmOrR-g@mail.gmail.com>
References: <20120818021918.GA6499@localhost>
	 <1345380682.5158.201.camel@edumazet-glaptop>
	 <CAF1ivSaU_ur9BkKG3eAsNw7d+ND5xgYbPKutemVqNec3X9m4SA@mail.gmail.com>
	 <1345387532.5158.222.camel@edumazet-glaptop>
	 <CAF1ivSZK8Y2XpjUXVpNg=m=bs7bGCYqF0ZQU2u_YpEUrmOrR-g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Aug 2012 17:55:08 +0200
Message-ID: <1345391708.5158.225.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-08-19 at 23:05 +0800, Lin Ming wrote:
> On Sun, Aug 19, 2012 at 10:45 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > On Sun, 2012-08-19 at 22:15 +0800, Lin Ming wrote:
> >
> >> Will it still has problem if code goes here without sock_hold(sk)?
> >
> > Not sure of what you mean.
> 
> See my comments in the function.
> Is that a potential problem?
> 

No problem.

It always been like that. Thats the whole point having a refcount at the
first place.

The last sock_put(sk) should free the socket.



