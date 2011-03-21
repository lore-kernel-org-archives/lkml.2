Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab1CUVsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 17:48:42 -0400
Received: from usindmx01.hds.com ([207.126.252.12]:37473 "EHLO
	usindmx01.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab1CUVsj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 17:48:39 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Tony Luck <tony.luck@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Mar 2011 17:47:49 -0400
Subject: RE: [RFC] pstore: Don't use persistent store for normal shutdown
Thread-Topic: [RFC] pstore: Don't use persistent store for normal shutdown
Thread-Index: AcvoBnedmHmE+hsGQRG452pOKzTKsgACH07Q
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C14F5A4A0@USINDEVS01.corp.hds.com>
References: <4d8797d74168a6441@agluck-desktop.sc.intel.com>
	<5C4C569E8A4B9B42A84A977CF070A35B2C14F5A465@USINDEVS01.corp.hds.com>
 <AANLkTinG0381opyEFtM4P-OuFoG++b7kvpTC4McoL9E8@mail.gmail.com>
In-Reply-To: <AANLkTinG0381opyEFtM4P-OuFoG++b7kvpTC4McoL9E8@mail.gmail.com>
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

>Should I still try to save as much data in these cases? Saving 1 Kbyte would be
>enough to have the last dozen+ lines, including the critical
>    <0>[  536.970556] Restarting system.
>that you'd like to see.

On my assumption, critical information is the last dozen lines.
However, it depends on the situations how much data is needed or what kind of data is useful.

I think we should introduce a tunable parameter specifying how much data stores into persistent
ram when normal shutdown happens.

Seiji
