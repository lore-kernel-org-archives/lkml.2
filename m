Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab0IDBGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 21:06:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19191 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab0IDBGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 21:06:38 -0400
Date: Fri, 3 Sep 2010 18:06:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Vipin Mehta <vmehta@atheros.com>
Subject: Re: linux-next: Tree for September 3 (ar6k)
Message-Id: <20100903180614.81e5eee0.randy.dunlap@oracle.com>
In-Reply-To: <20100903135206.d9bc2093.sfr@canb.auug.org.au>
References: <20100903135206.d9bc2093.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010 13:52:06 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100902:


drivers/staging/ath6kl/htc2/AR6000/ar6k.c:29:43: error: AR6002/hw2.0/hw/mbox_host_reg.h: No such file or directory

which leads to lots of these (this is just a sample):

drivers/staging/ath6kl/htc2/AR6000/ar6k.c:227: error: implicit declaration of function 'INT_STATUS_ENABLE_ERROR_SET'
drivers/staging/ath6kl/htc2/AR6000/ar6k.c:228: error: implicit declaration of function 'INT_STATUS_ENABLE_CPU_SET'
drivers/staging/ath6kl/htc2/AR6000/ar6k.c:229: error: implicit declaration of function 'INT_STATUS_ENABLE_COUNTER_SET'
drivers/staging/ath6kl/htc2/AR6000/ar6k.c:232: error: implicit declaration of function 'INT_STATUS_ENABLE_MBOX_DATA_SET'
drivers/staging/ath6kl/htc2/AR6000/ar6k.c:245: error: implicit declaration of function 'CPU_INT_STATUS_ENABLE_BIT_SET'
drivers/staging/ath6kl/htc2/AR6000/ar6k.c:249: error: implicit declaration of function 'ERROR_STATUS_ENABLE_RX_UNDERFLOW_SET'
drivers/staging/ath6kl/htc2/AR6000/ar6k.c:250: error: implicit declaration of function 'ERROR_STATUS_ENABLE_TX_OVERFLOW_SET'
drivers/staging/ath6kl/htc2/AR6000/ar6k.c:254: error: implicit declaration of function 'COUNTER_INT_STATUS_ENABLE_BIT_SET'
drivers/staging/ath6kl/htc2/AR6000/ar6k.c:263: error: 'INT_STATUS_ENABLE_ADDRESS' undeclared (first use in this function)
drivers/staging/ath6kl/htc2/AR6000/ar6k.c:296: error: 'INT_STATUS_ENABLE_ADDRESS' undeclared (first use in this function)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
