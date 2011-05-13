Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561Ab1EMUvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 16:51:19 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40093 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759248Ab1EMUvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 16:51:17 -0400
Date: Fri, 13 May 2011 16:50:04 -0400 (EDT)
Message-Id: <20110513.165004.1636748018642899792.davem@davemloft.net>
To: jpirko@redhat.com
Cc: panweiping3@gmail.com, eric.dumazet@gmail.com, mirq-linux@rere.qmqm.pl,
        therbert@google.com, bhutchings@solarflare.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net:set valid name before calling ndo_init()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110513071508.GC2733@psychotron>
References: <1305251217-4254-1-git-send-email-panweiping3@gmail.com>
	<20110513071508.GC2733@psychotron>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 13 May 2011 13:50:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jpirko@redhat.com>
Date: Fri, 13 May 2011 09:15:09 +0200

> Fri, May 13, 2011 at 03:46:56AM CEST, panweiping3@gmail.com wrote:
>>In commit 1c5cae815d19 (net: call dev_alloc_name from register_netdevice),
>>a bug of bonding was invloved, see example 1 and 2.
 ...
> 
> Reviewed-by: Jiri Pirko <jpirko@redhat.com>

Applied, thanks everyone.
