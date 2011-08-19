Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab1HSSlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 14:41:32 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56697 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab1HSSlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 14:41:31 -0400
Date: Fri, 19 Aug 2011 11:41:29 -0700 (PDT)
Message-Id: <20110819.114129.1090402357883712348.davem@davemloft.net>
To: guyyur@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Failed neighbors attached to routes are not
 released
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAC67Hz_G9cs7zECFmJ9a=twJfEUMja3eBGzAFvryUh+BpTTETw@mail.gmail.com>
References: <CAC67Hz_G9cs7zECFmJ9a=twJfEUMja3eBGzAFvryUh+BpTTETw@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 19 Aug 2011 11:41:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This will get more traction if you post it to the networking development
list (netdev@vger.kernel.org), as most of the core networking developers
do not read linux-kernel.

Also, posting patches to netdev gets that patch queued up and tracked
in our networking patch tracking system at:

	http://patchwork.ozlabs.org/project/netdev/list/

Thanks.
