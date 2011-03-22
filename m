Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab1CVWSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:18:12 -0400
Received: from usindmx01.hds.com ([207.126.252.12]:40216 "EHLO
	usindmx01.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab1CVWSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:18:10 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony" <tony.luck@intel.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 Mar 2011 18:17:16 -0400
Subject: RE: [RFC] pstore: Don't use persistent store for normal shutdown
Thread-Topic: [RFC] pstore: Don't use persistent store for normal shutdown
Thread-Index: AcvoyyhirdmLJXvzRnW98K72gc6MnwAE3ffA
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C14F5AA6A@USINDEVS01.corp.hds.com>
References: <1300783365.2735.12.camel@localhost>
 <4d88fec9598644f42@agluck-desktop.sc.intel.com>
In-Reply-To: <4d88fec9598644f42@agluck-desktop.sc.intel.com>
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

>-----Original Message-----
>From: Luck, Tony [mailto:tony.luck@intel.com]
>Sent: Tuesday, March 22, 2011 3:56 PM
>To: Artem Bityutskiy
>Cc: linux-kernel@vger.kernel.org; Seiji Aguchi; David Woodhouse; Marco Stornelli; KOSAKI Motohiro; Andrew Morton; Linus
>Torvalds
>Subject: Re: [RFC] pstore: Don't use persistent store for normal shutdown
>
>From: Tony Luck <tony.luck@intel.com>
>
>pstore_dump() can be called with many different "reason" codes. Save
>the name of the code in the persistent store record.
>
>Also - only worthwhile calling pstore_mkfile for KMSG_DUMP_OOPS - that
>is the only one where the kernel will continue running.
>
>Signed-off-by: Tony Luck <tony.luck@intel.com>
>

Looks good to me.

Reviewed-by: Seiji Aguchi <seiji.aguchi@hds.com>

