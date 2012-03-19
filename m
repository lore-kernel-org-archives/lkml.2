Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031760Ab2CSO7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 10:59:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:29028 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030905Ab2CSO7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 10:59:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="79172345"
From: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
To: Chris Boot <bootc@bootc.net>
CC: netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: RE: e1000e interface hang on 82574L
Thread-Topic: e1000e interface hang on 82574L
Thread-Index: AQHNBFb0txWMPFrR+EquP00KIfN6c5ZvOp6AgAJ9ONA=
Date: Mon, 19 Mar 2012 14:59:41 +0000
Message-ID: <9BBC4E0CF881AA4299206E2E1412B6260E512E0C@ORSMSX102.amr.corp.intel.com>
References: <4EFA4024.5000909@bootc.net>
 <FCF3184D-CE4F-471C-B66C-0F671795FD3C@bootc.net>
 <9BBC4E0CF881AA4299206E2E1412B626017762@ORSMSX102.amr.corp.intel.com>
 <4F048861.8070501@bootc.net> <4F12B42C.9030803@bootc.net>
 <9BBC4E0CF881AA4299206E2E1412B62621F0B1@ORSMSX102.amr.corp.intel.com>
 <4F144A76.3050703@bootc.net> <4F64B4E2.20208@bootc.net>
 <4F64CFCB.7060702@bootc.net>
In-Reply-To: <4F64CFCB.7060702@bootc.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2JExqOZ027569



>-----Original Message-----
>From: Chris Boot [mailto:bootc@bootc.net]
>Sent: Saturday, March 17, 2012 10:54 AM
>To: Wyborny, Carolyn
>Cc: netdev; lkml; e1000-devel@lists.sourceforge.net
>Subject: Re: e1000e interface hang on 82574L
[...]
>> Carolyn,
>>
>> I've just had the opportunity to upgrade to a 3.2.9 kernel on these
>> systems and have made sure e1000e is loaded with IntMode=1,1. One of
>the
>> servers was only up 5.5 hours before the NIC has crashed/stopped
>working
>> again.
Hello Chris,

The ASPM problem with 82574L is hardware based and is not solvable in software other than to disable it.  Since the platforms vary in their reliability in disabling the feature from the driver, your best option is to always boot with pcie_aspm=off with that part in the system.  

[...]
>Most notably it appears as though MSI-X is not enabled on the
>Supermicro, and ASPM L1 is. There appears to be no difference on the
>Supermicro as to the MSI-X status when booting with IntMode=1,1 compared
>to without it.
>
>Thanks,
>Chris

So, at least we are clear in your situation, the ASPM needs to be disabled.  Please let me know if there are continued problems after booting with pcie_aspm=off.

Thanks,

Carolyn

Carolyn Wyborny
Linux Development
LAN Access Division
Intel Corporation


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
