Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab2DDHyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 03:54:40 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42751 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab2DDHyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 03:54:38 -0400
Date: Wed, 04 Apr 2012 03:52:22 -0400 (EDT)
Message-Id: <20120404.035222.1873553360219906110.davem@davemloft.net>
To: sam@ravnborg.org
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, geert@linux-m68k.org,
        linux-m68k@vger.kernel.org, gerg@uclinux.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH] irq: remove obsolete definitions in interrupt.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120404074553.GA14959@merkur.ravnborg.org>
References: <20120404074553.GA14959@merkur.ravnborg.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 04 Apr 2012 00:52:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Wed, 4 Apr 2012 09:45:54 +0200

> interrupt.h contained a small fixlet for the days when
> m68k and sparc32 did not use genirq.
> As they have both entered the modern world this
> fixlet can be dropped.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

Acked-by: David S. Miller <davem@davemloft.net>
