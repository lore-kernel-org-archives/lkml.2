Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab1FBVoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 17:44:21 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50584 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab1FBVoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 17:44:20 -0400
Date: Thu, 02 Jun 2011 14:42:05 -0700 (PDT)
Message-Id: <20110602.144205.1691129951056490754.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: sam@ravnborg.org, daniel@gaisler.com, tglx@linutronix.de,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: Do not select GENERIC_HARDIRQS_NO_DEPRECATED
From: David Miller <davem@davemloft.net>
In-Reply-To: <1306568396-10438-1-git-send-email-geert@linux-m68k.org>
References: <1306568396-10438-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 02 Jun 2011 14:42:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sat, 28 May 2011 09:39:56 +0200

> Config option GENERIC_HARDIRQS_NO_DEPRECATED was removed in commit
> 78c89825649a9a5ed526c507603196f467d781a5 ("genirq: Remove the now obsolete
> config options and select statements"), but the select was accidentally
> reintroduced in commit 6baa9b20a68a88c2fd751cbe8d7652009379351b
> ("sparc32: genirq support")
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

I'll apply this, thanks Geert.
