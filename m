Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab0C1ELw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 00:11:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53931
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990Ab0C1ELu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 00:11:50 -0400
Date: Sat, 27 Mar 2010 21:12:13 -0700 (PDT)
Message-Id: <20100327.211213.13750482.davem@davemloft.net>
To: julia@diku.dk
Cc: peterz@infradead.org, mingo@elte.hu, tglx@linutronix.de, oleg@redhat.com,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/7] arch/sparc/kernel: Use set_cpus_allowed_ptr
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1003262303500.6480@ask.diku.dk>
References: <Pine.LNX.4.64.1003262303500.6480@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Fri, 26 Mar 2010 23:04:09 +0100 (CET)

> Use set_cpus_allowed_ptr rather than set_cpus_allowed.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thanks Julia.
