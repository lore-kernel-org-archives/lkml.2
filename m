Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509Ab2GCXFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 19:05:33 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:56225 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913Ab2GCXFb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 19:05:31 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Scan Subscription <scan-subscription@coverity.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Robert Love <robert.w.love@intel.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Mattia Dongili <malattia@linux.it>, Matthew Garrett <mjg@redhat.com>
Date: Tue, 3 Jul 2012 16:05:12 -0700
Subject: RE: New Defects based on recent changes in Kernel code found by
 Coverity Scan
Thread-Topic: New Defects based on recent changes in Kernel code found by
 Coverity Scan
Thread-Index: Ac1Zaw9CCY7mTXZGS9WtlVrWlDQHEAABO71Q
Message-ID: <477F20668A386D41ADCC57781B1F7043083AA54EEC@SC-VEXCH1.marvell.com>
References: <829BE905228AE14A9AE1A46E6F2E371605538D039D@VA3DIAXVS891.RED001.local>
 <20120703152739.ea7df9e6.akpm@linux-foundation.org>
In-Reply-To: <20120703152739.ea7df9e6.akpm@linux-foundation.org>
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

Hi Andrew,

> > *. CID 709078: Resource leak (RESOURCE_LEAK) - drivers/net/wireless/mwifiex/cfg80211.c, line: 935
> > Assigning: "bss_cfg" = storage returned from "kzalloc(132UL, 208U)" - but was not free
> > drivers/net/wireless/mwifiex/cfg80211.c:935
> 
> bzhao

Just posted a patch (for 3.5) to fix this leak.

Thanks,
Bing

