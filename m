Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1JSEJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 00:09:47 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:47156 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab1JSEJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 00:09:45 -0400
Date: Wed, 19 Oct 2011 00:09:32 -0400 (EDT)
Message-Id: <20111019.000932.523712028439316177.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        htejun@gmail.com, fubar@us.ibm.com, andy@greyhouse.net
Subject: Re: [PATCH 0/5] Better namespace handling for
 /sys/class/net/bonding_masters
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1hb3dbae5.fsf@fess.ebiederm.org>
References: <m1hb3dbae5.fsf@fess.ebiederm.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 18 Oct 2011 21:09:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 13 Oct 2011 00:47:46 -0700

> Greg, Dave I'm don't know whose tree to merge this through as this code
> is equally device-core and networking.  I am hoping that we can get this
> improvement merged for 3.2.

I'm happy to take this series into my net-next tree.

Greg?  Any objections?

