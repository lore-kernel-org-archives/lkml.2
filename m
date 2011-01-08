Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1AHAcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 19:32:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:45114 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab1AHAct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 19:32:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,292,1291622400"; 
   d="scan'208";a="875548392"
From: "Luck, Tony" <tony.luck@intel.com>
To: Meelis Roos <mroos@linux.ee>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Fri, 7 Jan 2011 16:32:02 -0800
Subject: RE: 2.6.37 compile failure on IA64: NODE_DATA
Thread-Topic: 2.6.37 compile failure on IA64: NODE_DATA
Thread-Index: AcuuhKmVhDyrucIlTkiHW9s8Ge4wcAARhPKQ
Message-ID: <987664A83D2D224EAE907B061CE93D530194010771@orsmsx505.amr.corp.intel.com>
References: <alpine.SOC.1.00.1101071731100.21434@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.1101071731100.21434@math.ut.ee>
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

> This is my first try at compiling my own machine-specific kernels for 
> IA64 and I stepped on a bug at once (but I have no ide if this 
> configuration worked before). It seems that since NEED_MULTIPLE_NODES is 
> set to y, NODE_DATA should be defined in asm/mmzone.h but isn't.

There may be many corner cases where you can create .config
files that do not build on ia64 (on x86 people regularly
generate random config files and then fix Kconfig dependencies
that allow impossible permutations - but nobody is doing that
for ia64).

Unless you have a particular attachment to the config
file you used, you might be better off starting from
arch/ia64/configs/generic_defconfig ... which is known
to build, and should boot on most machines.

-Tony
