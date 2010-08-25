Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0HYWfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 18:35:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44888
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752670Ab0HYWfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 18:35:41 -0400
Date: Wed, 25 Aug 2010 15:35:57 -0700 (PDT)
Message-Id: <20100825.153557.28797570.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next - trivial] drivers/net: Remove address use
 from assignments of function pointers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1282623603-31052-2-git-send-email-joe@perches.com>
References: <1282623603-31052-1-git-send-email-joe@perches.com>
	<1282623603-31052-2-git-send-email-joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 23 Aug 2010 21:20:03 -0700

> "foo = &function" is more commonly written "foo = function"
> 
> Done with coccinelle script:
 ...
> drivers/net/tehuti.c used a function and struct with the
> same name, the function was renamed.
> 
> Compile tested x86 only.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks.
