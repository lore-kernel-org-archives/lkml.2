Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2GIVK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 17:10:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59200 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab2GIVK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 17:10:56 -0400
Date: Mon, 09 Jul 2012 14:10:55 -0700 (PDT)
Message-Id: <20120709.141055.2204523729214009350.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hayeswang@realtek.com
Subject: Re: [PATCH net-next 1/2] r8169: support RTL8106E
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120709101215.GA6530@electric-eye.fr.zoreil.com>
References: <20120706152006.GA6981@electric-eye.fr.zoreil.com>
	<20120708.234857.1032244145219683435.davem@davemloft.net>
	<20120709101215.GA6530@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francois Romieu <romieu@fr.zoreil.com>
Date: Mon, 9 Jul 2012 12:12:15 +0200

> David Miller <davem@davemloft.net> :
>> Francois, what would you like me to do with these two patches?  I
>> haven't seen full ACKs from you yet.
> 
> You have two options:
> - You can apply the first (8106) patch. I tested it. I'm ok with Hayes point.
>   Consider it Acked.
> - You wait for a pull request with both patches + the incremental bits for
>   the second one. Some of the incremental bits are needed in the original
>   patch itself while some make more sense before the patch itself.
>   ETA: this evening or tomorrow morning at worst.
> 
> If you go for the first option, I'll simply skip the first patch and
> apply again. It's the same work for me.

I'll simply wait for your pull request, thank you.
