Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab2BQI61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 03:58:27 -0500
Received: from senator.holtmann.net ([87.106.208.187]:54513 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab2BQI6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 03:58:25 -0500
Message-ID: <1329469103.28848.147.camel@aeonflux>
Subject: Re: [PATCH 1/2] bluetooth: Use more current logging styles
From: Marcel Holtmann <marcel@holtmann.org>
To: David Miller <davem@davemloft.net>
Cc: padovan@profusion.mobi, joe@perches.com, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Fri, 17 Feb 2012 09:58:23 +0100
In-Reply-To: <20120216.163303.443981736744424334.davem@davemloft.net>
References: <1329184963.8143.2.camel@joe2Laptop>
	 <1329410631.10890.3.camel@joe2Laptop> <20120216180507.GA5280@joana>
	 <20120216.163303.443981736744424334.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> > Such a change will require rebase from all our developers and we already have
> > enough issues to solve, I don't wanna add one more here. Change what BT_*
> > stands for is ok, but there is no need to change the macros names. 
> 
> I would never push back on Joe on a change like this, the way that
> you are, and changes in my tree have an effect on 100 times more
> people than your's.
> 
> You're being completely unreasonable, and I'm rather confident that in
> response to what I'm saying you will simply start pulling more reasons
> out of thin air simply because you just don't want the change and the
> merge hassles.

I am actually fine with his reworked patchset, except the last patch
with the BT_DBG change. That will step on too many people toes right now
and I am also failing to see the benefit of that one.

Regards

Marcel


