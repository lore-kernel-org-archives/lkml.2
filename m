Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab2ATFp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 00:45:27 -0500
Received: from mtv-iport-2.cisco.com ([173.36.130.13]:15003 "EHLO
	mtv-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2ATFpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 00:45:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAMP+GE+rRDoJ/2dsb2JhbABDrXuBBYFyAQEBBBIBJwIBESsSAQgOCl8mAQEEAQcGBR0EAYdimjIBnkOMJgSIPIxckmw
X-IronPort-AV: E=Sophos;i="4.71,540,1320624000"; 
   d="scan'208";a="26309579"
User-Agent: Microsoft-Entourage/12.20.0.090605
Date: Thu, 19 Jan 2012 21:45:22 -0800
Subject: Re: linux-next: Tree for Jan 19 (cisco/enic)
From: Roopa Prabhu <roprabhu@cisco.com>
To: Roopa Prabhu <roprabhu@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "Christian Benvenuti (benve)" <benve@cisco.com>
Message-ID: <CB3E3F72.412F2%roprabhu@cisco.com>
Thread-Topic: linux-next: Tree for Jan 19 (cisco/enic)
Thread-Index: AczW/ALA7ahkcMLsTrC7MkSN6mZmXAAORDo0AABn3I8=
In-Reply-To: <CB3E3CB9.412EA%roprabhu@cisco.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 20 Jan 2012 05:45:23.0085 (UTC) FILETIME=[B3C093D0:01CCD736]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On 1/19/12 9:33 PM, "Roopa Prabhu" <roprabhu@cisco.com> wrote:

> 
> 
> 
> On 1/19/12 3:43 PM, "Randy Dunlap" <rdunlap@xenotime.net> wrote:
> 
>> On 01/18/2012 05:59 PM, Stephen Rothwell wrote:
>>> Hi all,
>>> 
>>> Changes since 20120118:
>> 
>> 
>> on x86_64:
>> 
>> /next/linux-next-20120119/drivers/net/ethernet/cisco/enic/enic_main.c: In
>> function 'enic_probe':
>> 
/next/linux-next-20120119/drivers/net/ethernet/cisco/enic/enic_main.c:2387:16>>
:
>> error: 'struct enic' has no member named 'num_vfs'
>> 
/next/linux-next-20120119/drivers/net/ethernet/cisco/enic/enic_main.c:2387:32>>
:
>> error: 'struct enic' has no member named 'num_vfs'
>> 
>> 
>> Full randconfig file is attached.
>> 
>> --
>> ~Randy
>> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>> 
> Thanks for reporting stephen. Its because you don't have CONFIG_PCI_IOV
> enabled. I will working on the patch. Will submit soon.
> 
Actually thanks randy. Patch coming soon..

> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

