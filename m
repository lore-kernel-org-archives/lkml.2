Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab1HLCx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 22:53:58 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33646 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab1HLCx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 22:53:57 -0400
Date: Thu, 11 Aug 2011 19:51:50 -0700 (PDT)
Message-Id: <20110811.195150.1070520107072994432.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <1313116296.2057.30.camel@jtkirshe-mobl>
References: <20110812120248.a23ecc95e9c1111da3a8ef30@canb.auug.org.au>
	<1313116296.2057.30.camel@jtkirshe-mobl>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 11 Aug 2011 19:51:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu, 11 Aug 2011 19:31:35 -0700

> I am curious, can you compile the Sun GEM support driver?  and if so,
> does the Spider Net driver compile?

I'm pretty sure you cannot reference object targets outside of
the current directory and expect it to work.

You can only reference things in the current directory (objects,
directories to traverse down into, etc.) as targets

So when there is a common piece of infrastructure shared by
two drivers, you're really going to have to cope with them
at the same time.
