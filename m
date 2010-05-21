Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab0EUFwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 01:52:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50830 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab0EUFwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 01:52:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=M3dVpaB2Bsv0GrJblwXLT4u8X97gZylJt2b2gdwGwr8XNmqNMnHMMPfL9VcAYd9ozG
         Gb21egolCzWdKlfL4gel8gzl2zM9DafrazKJN4kDcSo72RqtxDylYZCHfBn7j5nTexdE
         8f87pHQvlyxnno1cJJpk1+UBwSi9naveKyjCs=
Subject: Re: linux-next: build failure after merge of the suspend tree
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, linville@tuxdriver.com,
       torvalds@linux-foundation.org, rjw@sisk.pl, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Helmut.Schaa@gmx.de,
       netdev@vger.kernel.org
In-Reply-To: <20100520.224644.21290162.davem@davemloft.net>
References: <20100507130821.3fb72c9d.sfr@canb.auug.org.au>
	 <201005080413.24465.rjw@sisk.pl>
	 <20100521102913.ae4e8cd2.sfr@canb.auug.org.au>
	 <20100520.224644.21290162.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 07:51:57 +0200
Message-ID: <1274421117.4977.9.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 20 mai 2010 à 22:46 -0700, David Miller a écrit :
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 21 May 2010 10:29:13 +1000
> 
> > On Sat, 8 May 2010 04:13:24 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> >>
> >> On Friday 07 May 2010, Stephen Rothwell wrote:
> >> Both trees are based on Linus' current and I don't see a good way of fixing
> >> this issue in any of them individually.
> > 
> > The suspend tree has been merged into Linus' tree, so this patch is
> > needed in the net tree before it is merged (or as part of the merge).
> 
> Since the net tree is still on it's way to Linus, we'll just have to
> wait for him to do that merge.
> 
> Then we can sort this out.  I don't want to touch a tree that is
> already on it's way.

Linus merged your tree David.



