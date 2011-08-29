Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab1H2WPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 18:15:40 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60674 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab1H2WPg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 18:15:36 -0400
Date: Mon, 29 Aug 2011 18:15:20 -0400 (EDT)
Message-Id: <20110829.181520.933815499847625814.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: joe@perches.com, vladislav.yasevich@hp.com, sri@us.ibm.com,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/24] sctp: Remove unnecessary OOM logging messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <1314654681.2563.10.camel@edumazet-laptop>
References: <21b4d996c8861373ac77d427914ec7882fe0c83e.1314650069.git.joe@perches.com>
	<1314654209.2563.7.camel@edumazet-laptop>
	<1314654681.2563.10.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 29 Aug 2011 15:15:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 29 Aug 2011 23:51:21 +0200

> Le lundi 29 août 2011 à 23:43 +0200, Eric Dumazet a écrit :
> 
>> Furthermore, a failed vmalloc() is not guaranteed to emit an OOM
>> message, is it ?
> 
> It currently displays a message without context :
> 
> vmap allocation for size XXXXXX failed: use vmalloc=<size> to increase
> size.
> 
> So we dont know which part of the kernel asked this allocation.
> 
> Please dont remove existing error messages after failed vmalloc() calls.

Indeed.

Joe, these vmalloc() and also the __GFP_NOWARN cases will need to be
attended to and this series resubmitted as such.

Thanks.
