Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab1A0Sf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 13:35:28 -0500
Received: from mga14.intel.com ([143.182.124.37]:23779 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab1A0SfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 13:35:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,387,1291622400"; 
   d="scan'208";a="380813046"
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
Date: Thu, 27 Jan 2011 10:35:21 -0800
Subject: RE: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk	upon
 panic
Thread-Topic: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk
	upon panic
Thread-Index: Acu+Gd3MtSjygJgBSZqWBNs4fySvawANmVhA
Message-ID: <987664A83D2D224EAE907B061CE93D53019438F1BA@orsmsx505.amr.corp.intel.com>
References: <20110125134748.GA10051@laptop>
 <AANLkTinU0KYiCd4p=z+=ojbkeEoT2G+CAYvdRU02KJEn@mail.gmail.com>
 <20110126124954.GC24527@laptop>
 <987664A83D2D224EAE907B061CE93D53019438EABF@orsmsx505.amr.corp.intel.com>
 <20110126231620.GA14807@redhat.com>
 <987664A83D2D224EAE907B061CE93D53019438EB02@orsmsx505.amr.corp.intel.com>
 <20110126233033.GB14807@redhat.com>
 <987664A83D2D224EAE907B061CE93D53019438EBB6@orsmsx505.amr.corp.intel.com>
 <4D40F7F1.3020509@zytor.com> <20110127120039.GD20279@elte.hu>
In-Reply-To: <20110127120039.GD20279@elte.hu>
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

> - A bar code is encoded and i generally want to know what info i'm sending to
>   potentially untrusted parties ... also, i want to be sure i'm sending the right
>   oops, at a glance, before hitting 'send' on the email.

Maybe someone will write an iPhone/Android/Meego app that takes the picture, does
The decode and lets you look, together with options on whether to just send to
Your e-mail address, or to Cc; kerneloops?

> - A screenshot of a well-compressed oops output tells a lot of context as well:
>   surrounding kernel messages, general state of the system when it crashed.
>   Sometimes it tells me the type of the laptop as well, via the logo visible on the
>   border of the picture ;-) Context strengthens whether i can *trust* the oops - 
>   and often i'm really in doubt about oopses and want more context.

Perhaps some of this context can be encoded in the barcode too?

-Tony
