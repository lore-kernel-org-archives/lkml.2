Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab0IDCCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 22:02:39 -0400
Received: from mail.atheros.com ([12.19.149.2]:41033 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab0IDCCh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 22:02:37 -0400
From: Vipin Mehta <Vipin.Mehta@Atheros.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "gregkh@suse.de" <gregkh@suse.de>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 3 Sep 2010 19:02:36 -0700
Subject: RE: linux-next: Tree for September 3 (ar6k)
Thread-Topic: linux-next: Tree for September 3 (ar6k)
Thread-Index: ActLzWqzjLAnutYeRIKRSqvaxQXWIQABlHVQ
Message-ID: <35B17FE5076C7040809188FBE7913F983F23479B57@SC1EXMB-MBCL.global.atheros.com>
References: <20100903135206.d9bc2093.sfr@canb.auug.org.au>
 <20100903180614.81e5eee0.randy.dunlap@oracle.com>
In-Reply-To: <20100903180614.81e5eee0.randy.dunlap@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies for the inconvenience. I synced to the linux-next tree and looked into the drivers/staging/ath6kl directory. I was able to compile the driver without any issues.

One of the reasons this might happen is if the following symbolic link is broken.

drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw

The link should point to drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw.0

Can you pls send me the output of
ls -al drivers/staging/ath6kl/include/common/AR6002/hw2.0/

or if someone can help with the steps to reproduce the problem.

Regards,
Vipin

> -----Original Message-----
> From: Randy Dunlap [mailto:randy.dunlap@oracle.com]
> Sent: Friday, September 03, 2010 6:06 PM
> To: Stephen Rothwell; gregkh@suse.de
> Cc: linux-next@vger.kernel.org; LKML; Vipin Mehta
> Subject: Re: linux-next: Tree for September 3 (ar6k)
> 
> On Fri, 3 Sep 2010 13:52:06 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> >
> > Changes since 20100902:
> 
> 
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:29:43: error:
> AR6002/hw2.0/hw/mbox_host_reg.h: No such file or directory
> 
> which leads to lots of these (this is just a sample):
> 
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:227: error: implicit declaration
> of function 'INT_STATUS_ENABLE_ERROR_SET'
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:228: error: implicit declaration
> of function 'INT_STATUS_ENABLE_CPU_SET'
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:229: error: implicit declaration
> of function 'INT_STATUS_ENABLE_COUNTER_SET'
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:232: error: implicit declaration
> of function 'INT_STATUS_ENABLE_MBOX_DATA_SET'
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:245: error: implicit declaration
> of function 'CPU_INT_STATUS_ENABLE_BIT_SET'
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:249: error: implicit declaration
> of function 'ERROR_STATUS_ENABLE_RX_UNDERFLOW_SET'
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:250: error: implicit declaration
> of function 'ERROR_STATUS_ENABLE_TX_OVERFLOW_SET'
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:254: error: implicit declaration
> of function 'COUNTER_INT_STATUS_ENABLE_BIT_SET'
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:263: error:
> 'INT_STATUS_ENABLE_ADDRESS' undeclared (first use in this function)
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:296: error:
> 'INT_STATUS_ENABLE_ADDRESS' undeclared (first use in this function)
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code
> ***
