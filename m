Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab2DYSAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:00:20 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:52562 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab2DYSAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:00:19 -0400
Date: Wed, 25 Apr 2012 14:00:13 -0400 (EDT)
Message-Id: <20120425.140013.492374885239500514.davem@davemloft.net>
To: xchris89x@googlemail.com
Cc: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: many rx packets dropped since 2.6.37
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAOFJUki3Jg+fAWWY70nDUCdxVs5A5VGfwkwUn01a4BX+N5nm-A@mail.gmail.com>
References: <CAOFJUkj27aF6diDjcZFTyBaTdDdU8URkj+1vr3ECoozbzqDVBg@mail.gmail.com>
	<1335357975.3274.187.camel@edumazet-glaptop>
	<CAOFJUki3Jg+fAWWY70nDUCdxVs5A5VGfwkwUn01a4BX+N5nm-A@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 25 Apr 2012 11:00:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris <xchris89x@googlemail.com>
Date: Wed, 25 Apr 2012 16:38:59 +0200

> You will see many lost rx packets and i have no idea why???

You need to understand, the packet drops were always happening.  Both
before Eric's patch and afterwards.

The only change is that now they are counted in the statistics, so
you can actually _see_ it.

So asking to have Eric's patch reverted will only hide the situation
from you again, and is therefore quite a silly request.
