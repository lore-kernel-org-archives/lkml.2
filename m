Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934790Ab2DLViE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:38:04 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41904 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab2DLViC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:38:02 -0400
Date: Thu, 12 Apr 2012 17:35:24 -0400 (EDT)
Message-Id: <20120412.173524.316812345318278932.davem@davemloft.net>
To: eldad@fogrefinery.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ipv6/exthdrs.c et al: Optional strict PadN option
 checking
From: David Miller <davem@davemloft.net>
In-Reply-To: <CABe5r8JJPuhq3r=JnfLA=_U46-SFmK+g3XqC3MaRdLxwVXx9Qw@mail.gmail.com>
References: <1333811774-3219-1-git-send-email-eldad@fogrefinery.com>
	<20120412.160040.1086391259430365718.davem@davemloft.net>
	<CABe5r8JJPuhq3r=JnfLA=_U46-SFmK+g3XqC3MaRdLxwVXx9Qw@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 Apr 2012 14:35:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eldad Zack <eldad@fogrefinery.com>
Date: Thu, 12 Apr 2012 23:31:47 +0200

> That's the way I see it, as was my initial intent. Then I got
> concerned with the possibility that a communication with
> slightly-broken stack implementation (e.g., unsanitized buffers) would
> fail without the user being able to control it at runtime.
> Do you consider this a non-issue?

I think it's a non-issue.
