Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab0KXTQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:16:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41602
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754006Ab0KXTQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:16:51 -0500
Date: Wed, 24 Nov 2010 11:17:17 -0800 (PST)
Message-Id: <20101124.111717.102572573.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: vegard.nossum@gmail.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, eugene@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next-2.6] scm: lower SCM_MAX_FD
From: David Miller <davem@davemloft.net>
In-Reply-To: <1290557355.2866.117.camel@edumazet-laptop>
References: <AANLkTi=Q967xpX0KLMwX-=_4_1AKO5wjHEuJ1TrNjCj9@mail.gmail.com>
	<1290553918.2866.80.camel@edumazet-laptop>
	<1290557355.2866.117.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 24 Nov 2010 01:09:15 +0100

> [PATCH net-next-2.6] net: scm: lower SCM_MAX_FD
> 
> Lower SCM_MAX_FD from 255 to 253 so that allocations for scm_fp_list are
> halved. (commit f8d570a4 added two pointers in this structure)
> 
> scm_fp_dup() should not copy whole structure (and trigger kmemcheck
> warnings), but only the used part. While we are at it, only allocate
> needed size.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Also applied, thanks Eric.
