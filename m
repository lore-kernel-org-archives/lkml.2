Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab2AKKwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 05:52:46 -0500
Received: from dgate10.ts.fujitsu.com ([80.70.172.49]:30482 "EHLO
	dgate10.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab2AKKwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 05:52:44 -0500
DomainKey-Signature: s=s1536a; d=ts.fujitsu.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:Received:From:To:CC:
   Date:Subject:Thread-Topic:Thread-Index:Message-ID:
   References:In-Reply-To:Accept-Language:Content-Language:
   X-MS-Has-Attach:X-MS-TNEF-Correlator:acceptlanguage:
   Content-Type:Content-Transfer-Encoding:MIME-Version;
  b=Rf+QldA4jey43u7tT4kzFWqhhe0NSizHf0QhbB+1Wd5eZEWsvMSrJdkI
   7BkRfhnKsutTgT2FT7TXepvB0X1Qck2el/8lWO4TjNqVneQOgX0R3R9AC
   KD5NPULmdoaJQ2gWf96HVNtmFt593DUJF+SB/FwEZ+xn9pAA68cyVCj94
   JTCWSykt1KmdPWgAdeRLhZtCo4wY1VqRwN+3fgtIieLJMWsZqGz+NNFfo
   csHbgp/7kaePG/7JiZpVHOm3uBdi7;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.71,492,1320620400"; 
   d="scan'208";a="98066156"
From: "Borzenkov, Andrey" <andrey.borzenkov@ts.fujitsu.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 11 Jan 2012 11:52:40 +0100
Subject: RE: Extermeley large PageTables over 500G on kernel 2.6.32.49
 (SLES11 SP1)
Thread-Topic: Extermeley large PageTables over 500G on kernel 2.6.32.49
 (SLES11 SP1)
Thread-Index: AczQTOpqTE9DYTWrQHKTBZQ6Bl7dGQAAUgyA
Message-ID: <CB1B361E45A85849902B25342E88900501CFDC311187@ABGEX70E.FSC.NET>
References: <CB1B361E45A85849902B25342E88900501CFDC3110D6@ABGEX70E.FSC.NET>
 <1326278196.2767.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1326278196.2767.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0BAqrBk016680



> -----Original Message-----
> From: Eric Dumazet [mailto:eric.dumazet@gmail.com]
> Sent: Wednesday, January 11, 2012 2:37 PM
> To: Borzenkov, Andrey
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: Extermeley large PageTables over 500G on kernel 2.6.32.49
> (SLES11 SP1)
> 
> Le mercredi 11 janvier 2012 Ã  11:18 +0100, Borzenkov, Andrey a Ã©crit :
> 
> > What can be the reason for system consuming half of physical memory for
> page tables?
> >
> 
> Why dont you use hugepages to map oracle SGA ?
> 

Colleagues responsible for Oracle are reconfiguring it now.

> If not, its normal to eat so much memory for page tables
> 
> grep VmPTE /proc/*/status
> 
> 

Forgive my ignorance. I thought that

1. PTE is 8 bytes per page, which is 4K which gives 2K per 1M of memory
2. All processes sharing the same shared memory share the same page table

So page table for Oracle SGA 500G would be around 1G and shared by all Oracle clients. Is my assumption incorrect?
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
