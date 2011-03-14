Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab1CNV0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 17:26:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43324
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756584Ab1CNV0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 17:26:01 -0400
Date: Mon, 14 Mar 2011 14:26:39 -0700 (PDT)
Message-Id: <20110314.142639.102555050.davem@davemloft.net>
To: walken@google.com
Cc: shemminger@linux-foundation.org, netdev@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: fix build warnings with CONFIG_PM_SLEEP
 disabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110307021450.GC31188@google.com>
References: <20110307021450.GC31188@google.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel Lespinasse <walken@google.com>
Date: Sun, 6 Mar 2011 18:14:50 -0800

> This fixes a couple of build warnings when CONFIG_PM is enabled but
> CONFIG_PM_SLEEP is disabled. Applies on top of v2.6.38-rc7 - I know it's
> late, but it would be great if v2.6.38 could compile without warnings!
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>

I know it'd "be great" if this went into 2.6.38 but it doesn't fix
any real bugs, so I'm putting it into net-next-2.6

Thanks.
