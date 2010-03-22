Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab0CVRVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 13:21:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49713
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754820Ab0CVRVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:21:43 -0400
Date: Mon, 22 Mar 2010 10:22:06 -0700 (PDT)
Message-Id: <20100322.102206.148561893.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       therbert@google.com
Subject: Re: linux-next: Tree for March 22 (net-sysfs.c)
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BA78D3D.9090007@oracle.com>
References: <20100322171937.d753bdba.sfr@canb.auug.org.au>
	<4BA78D3D.9090007@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Mon, 22 Mar 2010 08:31:09 -0700

> When CONFIG_SYSFS is not enabled:
> 
> net/core/net-sysfs.c:742: error: implicit declaration of function 'rx_queue_remove_kobjects'
> net/core/net-sysfs.c:783: error: implicit declaration of function 'rx_queue_register_kobjects'
> 

Tom, please fix this.
