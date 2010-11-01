Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab0KAUdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 16:33:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49295
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753434Ab0KAUdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 16:33:05 -0400
Date: Mon, 01 Nov 2010 13:33:28 -0700 (PDT)
Message-Id: <20101101.133328.232758664.davem@davemloft.net>
To: jolsa@redhat.com
Cc: dhowells@redhat.com, lizf@cn.fujitsu.com, paul.moore@hp.com,
        johannes@sipsolutions.net, dipankar@in.ibm.com,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 3/3] net - removing superfluous rcu_read_lock_held check
From: David Miller <davem@davemloft.net>
In-Reply-To: <1288638909-10541-4-git-send-email-jolsa@redhat.com>
References: <1288638909-10541-1-git-send-email-jolsa@redhat.com>
	<1288638909-10541-4-git-send-email-jolsa@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>
Date: Mon,  1 Nov 2010 20:15:09 +0100

> the rcu_dereference_check is defined as
> 
> 	#define rcu_dereference_check(p, c) \
> 	   __rcu_dereference_check((p), rcu_read_lock_held() || (c), __rcu)
> 
> so the caller does not need to specify rcu_read_lock_held() condition.
>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
