Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab1HIXVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 19:21:06 -0400
Received: from tundra.namei.org ([65.99.196.166]:54616 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab1HIXVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 19:21:05 -0400
Date: Wed, 10 Aug 2011 09:20:58 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Patch] scm: Capture the full credentials of the scm sender
In-Reply-To: <1312908512.2576.97.camel@schen9-DESK>
Message-ID: <alpine.LRH.2.00.1108100920220.2830@tundra.namei.org>
References: <1312841316.2576.49.camel@schen9-DESK>  <1312857834.2531.15.camel@edumazet-laptop> <1312908512.2576.97.camel@schen9-DESK>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Aug 2011, Tim Chen wrote:

> This patch corrects an erroneous update of credential's gid with uid
> introduced in commit 257b5358b32f17 since 2.6.36.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>

Reviewed-by: James Morris <jmorris@namei.org>

-- 
James Morris
<jmorris@namei.org>
