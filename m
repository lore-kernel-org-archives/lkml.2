Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab0CQF7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 01:59:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54779
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752175Ab0CQF72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 01:59:28 -0400
Date: Tue, 16 Mar 2010 22:59:50 -0700 (PDT)
Message-Id: <20100316.225950.222623826.davem@davemloft.net>
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Patch] netpoll: allow spaces in its parameter
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BA07022.1040702@redhat.com>
References: <20100317055707.5013.72217.sendpatchset@localhost.localdomain>
	<20100316.225431.200776775.davem@davemloft.net>
	<4BA07022.1040702@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <amwang@redhat.com>
Date: Wed, 17 Mar 2010 14:01:06 +0800

> The problem is that the dst port is 0 when I even use:
> 
> "netconsole=@192.168.0.1/eth0, 66666@192.168.0.2/"
> 
> This is awful too? I don't think so...

It's very simple, don't use spaces.  Is it so difficult
to follow this rule?

"ipconfig" does it as do a host of other kernel command
line options.

There is no real reason to make netconsle= special in
this regard, really.
