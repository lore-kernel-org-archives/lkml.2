Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194Ab0I1EKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 00:10:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49634
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768Ab0I1EKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 00:10:11 -0400
Date: Mon, 27 Sep 2010 21:10:31 -0700 (PDT)
Message-Id: <20100927.211031.112600080.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: dipankar@in.ibm.com, holt@sgi.com, viro@zeniv.linux.org.uk, bcrl@kvack.org,
        den@openvz.org, mingo@elte.hu, mszeredi@suse.cz, cmm@us.ibm.com,
        npiggin@kernel.dk, xemul@openvz.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V3] fs: allow for more than 2^31 files
From: David Miller <davem@davemloft.net>
In-Reply-To: <1285645611.10438.27.camel@edumazet-laptop>
References: <20100923141037.GA3811@in.ibm.com>
	<20100927.153639.212415479.davem@davemloft.net>
	<1285645611.10438.27.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 28 Sep 2010 05:46:51 +0200

> [PATCH V3] fs: allow for more than 2^31 files
...
> Reported-by: Robin Holt <holt@sgi.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Acked-by: David S. Miller <davem@davemloft.net>
