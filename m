Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab1K1Wuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:50:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:25789 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab1K1Wut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:50:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="80635780"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, Udo Steinberg <udo@hypervisor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 28 Nov 2011 14:50:47 -0800
Subject: RE: MCE/Package power limit notification
Thread-Topic: MCE/Package power limit notification
Thread-Index: Acyp8gd0e6JYG39eTne0/UWpnlDM9AELSydgAAAudfA=
Message-ID: <493994B35A117E4F832F97C4719C4C04022D835792@orsmsx505.amr.corp.intel.com>
References: <20111123160950.67860131@x220>
 <987664A83D2D224EAE907B061CE93D53027D89B577@orsmsx505.amr.corp.intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D53027D89B577@orsmsx505.amr.corp.intel.com>
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
> From: Luck, Tony
> Sent: Monday, November 28, 2011 2:46 PM
> To: Udo Steinberg; Linux Kernel Mailing List
> Cc: Yu, Fenghua
> Subject: RE: MCE/Package power limit notification
> 
> > After half an hour of compiling code on an Intel SNB machine, at
> which time
> > the machine was more or less permanently running with turbo boost
> active,
> > I've gotten the following in my dmesg with Linux-3.1.0:
> >
> > CPU2: Package power limit notification (total events = 1)
> > CPU3: Package power limit notification (total events = 1)
> > CPU1: Package power limit notification (total events = 1)
> > CPU0: Package power limit notification (total events = 1)
> > ...
> 
> Udo,
> 
> Fenghua is looking at options to tone down these messages - reporting
> as machine checks is unduly scary.

Hi, Udo,

I sent out a patch to remove the mcelog info. Could you try it and see if it works for you?
https://lkml.org/lkml/2011/11/14/239

Thanks.

-Fenghua
