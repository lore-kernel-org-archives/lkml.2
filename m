Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab1ALIe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 03:34:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36167
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775Ab1ALIe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 03:34:27 -0500
Date: Wed, 12 Jan 2011 00:34:58 -0800 (PST)
Message-Id: <20110112.003458.09752771.davem@davemloft.net>
To: kees.cook@canonical.com
Cc: linux-kernel@vger.kernel.org, spender@grsecurity.net, segooon@gmail.com,
        jreuter@yaina.de, ralf@linux-mips.org
Subject: Re: [PATCH] net: ax25: fix information leak to userland harder
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110112054022.GR4979@outflux.net>
References: <20110112054022.GR4979@outflux.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <kees.cook@canonical.com>
Date: Tue, 11 Jan 2011 21:40:22 -0800

> Commit fe10ae53384e48c51996941b7720ee16995cbcb7 adds a memset() to clear
> the structure being sent back to userspace, but accidentally used the
> wrong size.
> 
> Reported-by: Brad Spengler <spender@grsecurity.net>
> Signed-off-by: Kees Cook <kees.cook@canonical.com>

Applied, thanks.
