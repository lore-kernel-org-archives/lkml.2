Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab0LBGAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 01:00:18 -0500
Received: from mga14.intel.com ([143.182.124.37]:43738 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756291Ab0LBGAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 01:00:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,286,1288594800"; 
   d="scan'208";a="355916288"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "greg@kroah.com" <greg@kroah.com>,
        "Huang, Ying" <ying.huang@intel.com>, Borislav Petkov <bp@alien8.de>,
        David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 1 Dec 2010 22:00:12 -0800
Subject: RE: [RFC] persistent store (version 2) (part 1 of 2)
Thread-Topic: [RFC] persistent store (version 2) (part 1 of 2)
Thread-Index: AcuRuy/7hczW6DC1QA2wfxKzLjpmXAAKfAzw
Message-ID: <987664A83D2D224EAE907B061CE93D530191F27E0E@orsmsx505.amr.corp.intel.com>
References: <4cf594e21679631af0@agluck-desktop.sc.intel.com>
 <20101201165139.a3bb2199.akpm@linux-foundation.org>
In-Reply-To: <20101201165139.a3bb2199.akpm@linux-foundation.org>
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

> filenames refer to files!  And lo, that's what we have here.  A
> filesystem!  The files are created by the kernel and are read and
> unlinked by userspace.
>
> So why not implement this whole thing as a proper filesystem?
...
> Wait.  It *is* a filesystem.
...
> So why can't I remove these "records" with rm?

Because I tried to use /sys for this and couldn't find a
way to get notified about "unlink".  Alan Cox called this
bit "daft" in v1 (and I agreed with him). Peter Anvin gave
me some pointers on how easy this would be to do as a real
filesystem ... so v3 will be out in a little while with
this insanity removed.

I'll roll in fixes to address your other comments too.

Thanks for the review.

-Tony
