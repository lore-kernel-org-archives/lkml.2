Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab2HRXYJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 19:24:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:60978 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468Ab2HRXXL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 19:23:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="204769320"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH 02/11] x86/lib/cpio.c: Find cpio data by its file name
Thread-Topic: [PATCH 02/11] x86/lib/cpio.c: Find cpio data by its file name
Thread-Index: AQHNfRumuaxUkE7c7EWoN7tGDr1vFJdgmFkA//+bcoA=
Date: Sat, 18 Aug 2012 23:23:08 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712200778794E@ORSMSX105.amr.corp.intel.com>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
 <1345277729-8399-3-git-send-email-fenghua.yu@intel.com>
 <20120818221252.GA32120@khazad-dum.debian.net>
In-Reply-To: <20120818221252.GA32120@khazad-dum.debian.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Henrique de Moraes Holschuh [mailto:hmh@hmh.eng.br]
> Sent: Saturday, August 18, 2012 3:13 PM
> To: Yu, Fenghua
> Cc: H Peter Anvin; Ingo Molnar; Thomas Gleixner; Mallick, Asit K;
> Tigran Aivazian; Andreas Herrmann; Borislav Petkov; linux-kernel; x86
> Subject: Re: [PATCH 02/11] x86/lib/cpio.c: Find cpio data by its file
> name
> 
> On Sat, 18 Aug 2012, Fenghua Yu wrote:
> > Given a file's name, find its starting point in a cpio formated area.
> This will
> > be used to find microcode in combined initrd image. But this function
> is
> > generic and could be used in other places.
> 
> Shouldn't this (very useful) feature get its own documentation in
> Documentation/ ?

Yes, I can document the feature. And if it's generic and useful, this function could be put in generic kernel instead of in x86 arch.

Thanks.

-Fenghua
