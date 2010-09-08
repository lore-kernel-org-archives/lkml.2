Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab0IHUqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 16:46:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44993
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557Ab0IHUqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 16:46:14 -0400
Date: Wed, 08 Sep 2010 13:46:32 -0700 (PDT)
Message-Id: <20100908.134632.35051274.davem@davemloft.net>
To: namhyung@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: remove address space warnings in net/socket.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1283867700-24132-1-git-send-email-namhyung@gmail.com>
References: <1283867700-24132-1-git-send-email-namhyung@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>
Date: Tue,  7 Sep 2010 22:55:00 +0900

> Casts __kernel to __user pointer require __force markup, so add it. Also
> sock_get/setsockopt() takes @optval and/or @optlen arguments as user pointers
> but were taking kernel pointers, use new variables 'uoptval' and/or 'uoptlen'
> to fix it. These remove following warnings from sparse:
...
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Applied to net-next-2.6, thank you.
