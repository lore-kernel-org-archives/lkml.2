Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab0GGWTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 18:19:12 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:32591 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756104Ab0GGWTK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 18:19:10 -0400
From: Shreyas Bhatewara <sbhatewara@vmware.com>
To: David Miller <davem@davemloft.net>
CC: "netdev-devel@vger.kernel.org" <netdev-devel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       Michael Stolarchuk <stolarchuk@vmware.com>
Date: Wed, 7 Jul 2010 15:19:08 -0700
Subject: RE: [PATCH 2.6.35-rc1] net: vmxnet3 fixes [0/5] Spare skb to avoid
 starvation
Thread-Topic: [PATCH 2.6.35-rc1] net: vmxnet3 fixes [0/5] Spare skb to avoid
 starvation
Thread-Index: AcseHQjuM/wyewWDQ6GmTo95aZfumQABHeCg
Message-ID: <89E2752CFA8EC044846EB8499819134102BD8D444B@EXCH-MBX-4.vmware.com>
References: <alpine.LRH.2.00.1007070125440.4652@localhost.localdomain>
 <20100707.144048.25140070.davem@davemloft.net>
In-Reply-To: <20100707.144048.25140070.davem@davemloft.net>
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



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Wednesday, July 07, 2010 2:41 PM
> To: Shreyas Bhatewara
> Cc: netdev-devel@vger.kernel.org; linux-kernel@vger.kernel.org; pv-
> drivers@vmware.com; Michael Stolarchuk
> Subject: Re: [PATCH 2.6.35-rc1] net: vmxnet3 fixes [0/5] Spare skb to
> avoid starvation
> 
> 
> A couple problems remaining in this patch set:
> 
> 1) Too many bug fixes for this late in the -rc series of 2.6.35
>    Pick a smaller number of fixes, the most critical ones, perhaps
>    2 or 3, and re-submit those for net-2.6
> 
>    Pick the ones that produce easily triggers crashes or documented
>    regressions present on the official lkml regression list.
> 
>    Send the rest in for net-next-2.6

Could you please apply all the patches in the series to net-next-2.6, the patches will apply cleanly. Or would you rather have them reposted them with proper subject line ?

> 
> 2) Bumping the driver version every patch in a patch series is
> pointless.
>    Do the bump once, at the end of the series.


The version numbers bumps although seemingly pointless (and harmless), make my life easy to track and maintain the bug#-to-fix mapping.


Thanks.
->Shreyas


> 
> Thanks.
