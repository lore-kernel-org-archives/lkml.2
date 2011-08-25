Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1HYCsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 22:48:11 -0400
Received: from mail.openrapids.net ([64.15.138.104]:35265 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752152Ab1HYCsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 22:48:10 -0400
Date: Wed, 24 Aug 2011 22:48:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, dgoulet@ev0ke.net,
        penguin-kernel@I-love.SAKURA.ne.jp, anton@samba.org, stable@kernel.org
Subject: Re: [PATCH 3.1-rc3/3.0.3] sendmmsg/sendmsg: fix unsafe user
	pointer access
Message-ID: <20110825024808.GA23807@Krystal>
References: <20110825023940.GA23683@Krystal> <20110824.194525.2193895272175663670.davem@davemloft.net> <20110824.194653.634810868160099262.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824.194653.634810868160099262.davem@davemloft.net>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 22:47:53 up 274 days,  7:50,  1 user,  load average: 0.04, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller (davem@davemloft.net) wrote:
> 
> BTW, please always post all networking patches to netdev@vger.kernel.org,
> this way it gets better review and the patch will also be properly tracked
> at:
> 
> 	http://patchwork.ozlabs.org/netdev/list/
> 
> Thanks.

Will do, thanks !

Mathieu

> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
