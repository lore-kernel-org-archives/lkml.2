Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab0DGXqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:46:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54996
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756144Ab0DGXql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:46:41 -0400
Date: Wed, 07 Apr 2010 16:46:44 -0700 (PDT)
Message-Id: <20100407.164644.96927208.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: eric.dumazet@gmail.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for April 7 (net/core/dev_addr_lists)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100407105049.0f812b27.randy.dunlap@oracle.com>
References: <20100407095845.f29ebf48.randy.dunlap@oracle.com>
	<1270661889.8141.45.camel@edumazet-laptop>
	<20100407105049.0f812b27.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Wed, 7 Apr 2010 10:50:49 -0700

> On Wed, 07 Apr 2010 19:38:09 +0200 Eric Dumazet wrote:
> 
>> [PATCH net-next-2.6] net: include linux/proc_fs.h in dev_addr_lists.c
>> 
>> As pointed by Randy Dunlap, we must include linux/proc_fs.h in
>> net/core/dev_addr_lists.c, regardless of CONFIG_PROC_FS
>> 
>> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>, 
>> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> 
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied, thanks everyone.
