Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945935Ab2JSQjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:39:15 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55486 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752296Ab2JSQjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:39:14 -0400
Message-ID: <1350664752.16440.3.camel@joe-AO722>
Subject: Re: [ath9k-devel] [PATCH net-next 00/21] treewide: Use consistent
 api style for address testing
From: Joe Perches <joe@perches.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, ath9k-devel <ath9k-devel@venema.h4ckr.net>
Date: Fri, 19 Oct 2012 09:39:12 -0700
In-Reply-To: <20121019115517.7b8514a8@mj>
References: <cover.1350618006.git.joe@perches.com>
	 <1350630254.2293.183.camel@edumazet-glaptop> <20121019115517.7b8514a8@mj>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc list trimmed)

On Fri, 2012-10-19 at 11:55 -0400, Pavel Roskin wrote:
> On Fri, 19 Oct 2012 09:04:14 +0200
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> > Yes they are some names discrepancies, thats a big deal.
> > 
> > And we have alloc_skb() / kfree_skb() / skb_clone() 
> > 
> > Why not skb_alloc() / skb_free() / skb_clone() ?
> > 
> > Some people actually know current code by name of functions, they dont
> > want to change their mind and having to grep include files and git log
> > to learn the new names of an old function, especially when traveling
> > and using a laptop.
> 
> I agree.
> 
> Also, it makes sense to introduce a more consistent name for a function
> when it's improved in some way and the callers need to be adjusted or
> re-checked.
> 
> That way, the old name can be phased out as the code is made compatible
> with the new function.

That can also be done, as was done with this series, with backward
compatible #defines.



