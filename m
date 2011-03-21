Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab1CUTuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 15:50:07 -0400
Received: from usindmx04.hds.com ([207.126.252.15]:65261 "EHLO
	usindmx04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab1CUTuD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 15:50:03 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Mar 2011 15:49:14 -0400
Subject: RE: [RFC] pstore: Don't use persistent store for normal shutdown
Thread-Topic: [RFC] pstore: Don't use persistent store for normal shutdown
Thread-Index: Acvn9Tz33M0HP8uWS0e0KukxNUy1rwABwu3Q
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C14F5A465@USINDEVS01.corp.hds.com>
References: <4d8797d74168a6441@agluck-desktop.sc.intel.com>
In-Reply-To: <4d8797d74168a6441@agluck-desktop.sc.intel.com>
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

Hi,

>Seiji Aguchi added kmsg_dump options for all the "normal" ways
>that a system can be shut down (KEXEC, RESTART, HALT and POWEROFF).
>It doesn't seem useful to save the kernel log to persistent store
>in these cases.

I think we should save the tail of kernel log into persistent store
for both every shutdown and kexec path because these data are useful
in enterprise area.

I already described the useful case in lkml (see below).

normal shutdown:
https://lkml.org/lkml/2010/11/17/249

kexec:
https://lkml.org/lkml/2011/2/23/325

Seiji
