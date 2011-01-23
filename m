Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab1AWTyY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 14:54:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50103
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752458Ab1AWTyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 14:54:23 -0500
Date: Sun, 23 Jan 2011 11:54:58 -0800 (PST)
Message-Id: <20110123.115458.183063678.davem@davemloft.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        sparclinux@vger.kernel.org
Subject: Re: [patch 4/9] sparc: Replace deprecated spinlock initialization
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110123143837.223928325@linutronix.de>
References: <20110123143631.392446736@linutronix.de>
	<20110123143837.223928325@linutronix.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 23 Jan 2011 15:17:04 -0000

> SPIN_LOCK_UNLOCK is deprecated. Use the lockdep capable variant
> instead.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: David S. Miller <davem@davemloft.net>
