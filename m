Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab1A0Em6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 23:42:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50711
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752808Ab1A0Em5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 23:42:57 -0500
Date: Wed, 26 Jan 2011 20:43:31 -0800 (PST)
Message-Id: <20110126.204331.226773480.davem@davemloft.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, dhowells@redhat.com,
        x86@kernel.org, benh@kernel.crashing.org, rth@twiddle.net,
        tony.luck@intel.com, heiko.carstens@de.ibm.com, lethal@linux-sh.org,
        chris@zankel.net
Subject: Re: [patch 1/6] rwsem: Cleanup includes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110126195833.483520950@linutronix.de>
References: <20110126195810.247325792@linutronix.de>
	<20110126195833.483520950@linutronix.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 26 Jan 2011 20:05:50 -0000

> All rwsem implementations include the same headers. Include them from
> include/linux/rwsem.h
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: David S. Miller <davem@davemloft.net>
