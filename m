Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab1A0S4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 13:56:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:60685 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab1A0S4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 13:56:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,387,1291622400"; 
   d="scan'208";a="597093634"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
CC: Dave Jones <davej@redhat.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        X86-ML <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>,
        "Hohndel, Dirk" <dirk.hohndel@intel.com>,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>,
        Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@suse.de>,
        Mark Lord <kernel@teksavvy.com>, Jeff Garzik <jgarzik@pobox.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
        FBDEV-ML <linux-fbdev@vger.kernel.org>
Date: Thu, 27 Jan 2011 10:56:39 -0800
Subject: RE: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk	upon
 panic
Thread-Topic: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk
	upon panic
Thread-Index: Acu+PsTMUp458TMIT8SOjxPyNP2IwwAFKoSA
Message-ID: <987664A83D2D224EAE907B061CE93D53019438F230@orsmsx505.amr.corp.intel.com>
References: <AANLkTinU0KYiCd4p=z+=ojbkeEoT2G+CAYvdRU02KJEn@mail.gmail.com>
 <20110126124954.GC24527@laptop>
 <987664A83D2D224EAE907B061CE93D53019438EABF@orsmsx505.amr.corp.intel.com>
 <20110126231620.GA14807@redhat.com>
 <987664A83D2D224EAE907B061CE93D53019438EB02@orsmsx505.amr.corp.intel.com>
 <20110126233033.GB14807@redhat.com>
 <987664A83D2D224EAE907B061CE93D53019438EBB6@orsmsx505.amr.corp.intel.com>
 <4D40F7F1.3020509@zytor.com> <20110127120039.GD20279@elte.hu>
 <4D4197CB.9070201@zytor.com> <20110127162429.GB26437@elte.hu>
In-Reply-To: <20110127162429.GB26437@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, i've done it countless times and it's very painful indeed - but the 
> alternative "losing context" would be even worse to me. Can we do both - i.e. have 
> the barcode on the screen alongside the oops itself? (although at that point they'll 
> be taking screen real estate from each other - degrading the information in *both* 
> venues.)
>
> Keyboard 'oops scrolling' driver with 'flip to barcode output' key? :-)

If we can make the screen scroll, or guarantee that a hot key will switch to
the barcode view, then those look like good solutions. Sharing space on a
non-scrollable view sounds like a poor choice. Perhaps better to have a
command line option to say which to provide (default = text).

-Tony
