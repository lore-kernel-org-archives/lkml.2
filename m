Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab2JMDTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 23:19:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53064 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab2JMDTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 23:19:45 -0400
Date: Fri, 12 Oct 2012 23:19:41 -0400 (EDT)
Message-Id: <20121012.231941.1930318153077157651.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 20/25] sparc: Use Kbuild infrastructure to handle
 asm-generic headers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121013022955.307620438@goodmis.org>
References: <20121013022632.024527228@goodmis.org>
	<20121013022955.307620438@goodmis.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Fri, 12 Oct 2012 22:26:52 -0400

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Use Kbuild infrastructure to handle the asm-generic headers
> and remove the wrapper headers that call them.
> 
> This only affects headers that do nothing but include the generic
> equivalent. It does not touch any header that does a little more.
> 
> Cc: linux-kbuild@vger.kernel.org
> Cc: sparclinux@vger.kernel.org
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: David S. Miller <davem@davemloft.net>
