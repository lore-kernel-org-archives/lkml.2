Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab0CQFyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 01:54:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57609
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752403Ab0CQFyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 01:54:11 -0400
Date: Tue, 16 Mar 2010 22:54:31 -0700 (PDT)
Message-Id: <20100316.225431.200776775.davem@davemloft.net>
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Patch] netpoll: allow spaces in its parameter
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100317055707.5013.72217.sendpatchset@localhost.localdomain>
References: <20100317055707.5013.72217.sendpatchset@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>
Date: Wed, 17 Mar 2010 01:53:26 -0400

> 
> It would be nice if we allow spaces in netconsole parameters,
> otherwise we get weird results if there are spaces in it.
> 
> After this patch, we will allow things like:
>  "netconsole= @192.168.0.1/eth0 , 66666@192.168.0.2/".
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: David Miller <davem@davemloft.net>

That kernel command line looks absolutely awful, not
better.

Sorry I'm not applying this.
