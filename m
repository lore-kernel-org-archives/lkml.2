Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1AVAu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 19:50:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51579
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750791Ab1AVAuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 19:50:55 -0500
Date: Fri, 21 Jan 2011 16:51:27 -0800 (PST)
Message-Id: <20110121.165127.113728879.davem@davemloft.net>
To: torbenh@gmx.de
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, johnstul@us.ibm.com,
        hch@infradead.org, yong.zhang0@gmail.com
Subject: Re: [PATCH 16/18] sparc: switch do_timer() to xtime_update()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1295651224-29823-17-git-send-email-torbenh@gmx.de>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
	<1295651224-29823-17-git-send-email-torbenh@gmx.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Torben Hohn <torbenh@gmx.de>
Date: Sat, 22 Jan 2011 00:07:02 +0100

> xtime_update() takes the xtime_lock itself.
> 
> i dont think that pcic_clear_clock_irq() and clear_clock_irq need
> to be protected by a lock.
> it might make sense to move them after xtime_update() though.
> 
> Signed-off-by: Torben Hohn <torbenh@gmx.de>

Agreed:

Acked-by: David S. Miller <davem@davemloft.net>
