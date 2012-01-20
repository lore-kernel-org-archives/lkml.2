Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab2ATFnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 00:43:49 -0500
Received: from mtv-iport-2.cisco.com ([173.36.130.13]:28620 "EHLO
	mtv-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2ATFnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 00:43:45 -0500
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jan 2012 00:43:45 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAIP8GE+rRDoH/2dsb2JhbABDrXuBBYFyAQEBAwESAScCATwFDQEIDgqBBQEBBAENBSKHWpo3AZ5EjCYEiDyMXJJs
X-IronPort-AV: E=Sophos;i="4.71,540,1320624000"; 
   d="scan'208";a="26308592"
User-Agent: Microsoft-Entourage/12.20.0.090605
Date: Thu, 19 Jan 2012 21:33:45 -0800
Subject: Re: linux-next: Tree for Jan 19 (cisco/enic)
From: Roopa Prabhu <roprabhu@cisco.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "Christian Benvenuti (benve)" <benve@cisco.com>,
        "David Wang (dwang2)" <dwang2@cisco.com>
Message-ID: <CB3E3CB9.412EA%roprabhu@cisco.com>
Thread-Topic: linux-next: Tree for Jan 19 (cisco/enic)
Thread-Index: AczW/ALA7ahkcMLsTrC7MkSN6mZmXAAORDo0
In-Reply-To: <4F18AA99.8010803@xenotime.net>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 20 Jan 2012 05:33:46.0469 (UTC) FILETIME=[14896950:01CCD735]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On 1/19/12 3:43 PM, "Randy Dunlap" <rdunlap@xenotime.net> wrote:

> On 01/18/2012 05:59 PM, Stephen Rothwell wrote:
>> Hi all,
>> 
>> Changes since 20120118:
> 
> 
> on x86_64:
> 
> /next/linux-next-20120119/drivers/net/ethernet/cisco/enic/enic_main.c: In
> function 'enic_probe':
> /next/linux-next-20120119/drivers/net/ethernet/cisco/enic/enic_main.c:2387:16:
> error: 'struct enic' has no member named 'num_vfs'
> /next/linux-next-20120119/drivers/net/ethernet/cisco/enic/enic_main.c:2387:32:
> error: 'struct enic' has no member named 'num_vfs'
> 
> 
> Full randconfig file is attached.
> 
> --
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
Thanks for reporting stephen. Its because you don't have CONFIG_PCI_IOV
enabled. I will working on the patch. Will submit soon.


