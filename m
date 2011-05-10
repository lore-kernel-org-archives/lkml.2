Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab1EJTmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 15:42:43 -0400
Received: from usindmx01.hds.com ([207.126.252.12]:63319 "EHLO
	usindmx01.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab1EJTml convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 15:42:41 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Borislav Petkov <bp@amd64.org>
CC: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "mikew@google.com" <mikew@google.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Tue, 10 May 2011 15:18:02 -0400
Subject: RE: [RFC][PATCH] pstore: EFI Support
Thread-Topic: [RFC][PATCH] pstore: EFI Support
Thread-Index: AcwPM2yEPP0hBEmLQzaySKC2Hl3JDgAEzPjw
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C16FB4815@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C16FB4712@USINDEVS01.corp.hds.com>
 <20110510161137.GA14522@kroah.com> <20110510165728.GC3347@gere.osrc.amd.com>
In-Reply-To: <20110510165728.GC3347@gere.osrc.amd.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for your comments.

>Btw, is this case of the possibility for APEI of corrupting NVRAM
>storage something you actually experienced on a real machine or simply a
>conclusion from looking at APEI code doing ioremap()?

I simply concluded from looking at ioremap() of APEI code.

Seiji
