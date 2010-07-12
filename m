Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab0GLBTJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 21:19:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41356 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab0GLBTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 21:19:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mmotm] 8250_early: fix printk format warnings
Cc: kosaki.motohiro@jp.fujitsu.com, Randy Dunlap <randy.dunlap@oracle.com>,
        linux-kernel@vger.kernel.org,
        Samium Gromoff <_deepfire@feelingofgreen.ru>, Greg KH <greg@kroah.com>
In-Reply-To: <20100709154644.f5d8877a.akpm@linux-foundation.org>
References: <20100709144148.3D25.A69D9226@jp.fujitsu.com> <20100709154644.f5d8877a.akpm@linux-foundation.org>
Message-Id: <20100712101823.EA13.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 12 Jul 2010 10:18:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This?
> 
> 	if (mmio || mmio32)
> 		printk(KERN_INFO
> 		       "Early serial console at MMIO%s 0x%llu (options '%s')\n",
> 			mmio32 ? "32" : "",
> 			(unsigned long long)port->mapbase,
> 			device->options);
> 	else
> 		printk(KERN_INFO
> 		      "Early serial console at I/O port 0x%lu (options '%s')\n",
> 			port->iobase,
> 			device->options);
> 

Looks good to me. thanks.



