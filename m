Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1K1WqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:46:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:43548 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233Ab1K1WqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:46:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,587,1315206000"; 
   d="scan'208";a="89955527"
From: "Luck, Tony" <tony.luck@intel.com>
To: Udo Steinberg <udo@hypervisor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>
Date: Mon, 28 Nov 2011 14:46:14 -0800
Subject: RE: MCE/Package power limit notification
Thread-Topic: MCE/Package power limit notification
Thread-Index: Acyp8gd0e6JYG39eTne0/UWpnlDM9AELSydg
Message-ID: <987664A83D2D224EAE907B061CE93D53027D89B577@orsmsx505.amr.corp.intel.com>
References: <20111123160950.67860131@x220>
In-Reply-To: <20111123160950.67860131@x220>
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

> After half an hour of compiling code on an Intel SNB machine, at which time
> the machine was more or less permanently running with turbo boost active,
> I've gotten the following in my dmesg with Linux-3.1.0:
>
> CPU2: Package power limit notification (total events = 1)
> CPU3: Package power limit notification (total events = 1)
> CPU1: Package power limit notification (total events = 1)
> CPU0: Package power limit notification (total events = 1)
> ...

Udo,

Fenghua is looking at options to tone down these messages - reporting
as machine checks is unduly scary.

-Tony
