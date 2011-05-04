Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab1EDSG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:06:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36440
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755170Ab1EDSGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:06:54 -0400
Date: Wed, 04 May 2011 11:06:21 -0700 (PDT)
Message-Id: <20110504.110621.115946620.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] x86/net: only select BPF_JIT when NET is enabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110504095651.60082594.randy.dunlap@oracle.com>
References: <20110504144759.802483cc.sfr@canb.auug.org.au>
	<20110504095651.60082594.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Wed, 4 May 2011 09:56:51 -0700

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kconfig unmet dependency warning: HAVE_BPF_JIT depends on NET, so
> make the "select" of it depend on NET also.
> 
> warning: (X86) selects HAVE_BPF_JIT which has unmet direct dependencies (NET)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied, thanks Randy.
