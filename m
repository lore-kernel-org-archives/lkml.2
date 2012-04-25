Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2DYImK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 04:42:10 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47071 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab2DYImI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 04:42:08 -0400
Date: Wed, 25 Apr 2012 10:42:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, apw@canonical.com
Subject: Re: Please fix or revert: [PATCH] checkpatch: add --strict tests for
 braces, comments and casts
Message-ID: <20120425084202.GB20853@gmail.com>
References: <20120416091719.GA4113@gmail.com>
 <20120416.142728.864894452301706752.davem@davemloft.net>
 <20120416202654.GA4678@gmail.com>
 <20120416.165804.411912709558079358.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120416.165804.411912709558079358.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Sorry about the late reply, was busy with other things.)

* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@kernel.org>
> Date: Mon, 16 Apr 2012 22:26:54 +0200
> 
> >     If you don't "see" it as ugly it's simply because your brain
> >     is not wired up to see 3D/2D geometry as a significant
> >     source of information.
> 
> I'm sorry that I'm so handicapped that I cannot match your
> visual capabilitites.

I genuinely think that it's the other way around: if what I say 
above is true then *you* have the superior vision for coding.

Geometric properties of code are a distraction really, they 
don't matter to the end result.

So in reality keeping comments balanced helps *my* disability: 
my inability to ignore functionally irrelevant patterns of 
characters...

So I am asking *you* to do me a favor: please understand my 
perspective and insert a bit more whitespace to keep code 
readable for people like me.

( The wider question is, what is the contribution weighted 
  proportion of the two groups of kernel developers and what is 
  the disutility and utility of the two variants. It's a 
  difficult balancing task and there's no perfect solution. )

Thanks,

	Ingo
