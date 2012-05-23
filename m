Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab2EWG1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:27:48 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34224 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab2EWG1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:27:46 -0400
Subject: Re: [PATCH] ipv4: fix the rcu race between free_fib_info and
 ip_route_output_slow
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, kunx.jiang@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1337753757.14538.190.camel@ymzhang.sh.intel.com>
References: <4FBB6105.2060808@intel.com>
	 <20120522.151554.106838106733194160.davem@davemloft.net>
	 <1337742123.14538.175.camel@ymzhang.sh.intel.com>
	 <20120522.232310.911242148705021745.davem@davemloft.net>
	 <1337747829.3361.1599.camel@edumazet-glaptop>
	 <1337748897.14538.184.camel@ymzhang.sh.intel.com>
	 <1337749339.3361.1655.camel@edumazet-glaptop>
	 <1337753757.14538.190.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 May 2012 08:27:39 +0200
Message-ID: <1337754459.3361.1850.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 14:15 +0800, Yanmin Zhang wrote:

> 
> Besides fi->fib_dev here, we need check fi->fib_hash, fi->fib_lhash,
> and nexthop_nh->nh_hash.

No, its not needed.

I am sending a patch, because I feel this area is too complex for non
netdev guys.



