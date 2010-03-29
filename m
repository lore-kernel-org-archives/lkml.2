Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab0C2IAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 04:00:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33104
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751631Ab0C2IAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 04:00:42 -0400
Date: Mon, 29 Mar 2010 01:01:04 -0700 (PDT)
Message-Id: <20100329.010104.214233589.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, therbert@google.com
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1269845970.2164.4.camel@edumazet-laptop>
References: <20100329174300.512d83a8.sfr@canb.auug.org.au>
	<1269845561.2164.1.camel@edumazet-laptop>
	<1269845970.2164.4.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 29 Mar 2010 08:59:30 +0200

> From: Stephen Rothwell <sfr@canb.auug.org.au>
 ...
> Oops, a cleaner patch would be :
> 
> [PATCH] rps: fix net-sysfs build for !CONFIG_RPS
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks guys!
