Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab1AZXHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 18:07:50 -0500
Received: from mga03.intel.com ([143.182.124.21]:8197 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab1AZXHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 18:07:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,382,1291622400"; 
   d="scan'208";a="380408298"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        X86-ML <x86@kernel.org>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        KEXEC-ML <kexec@lists.infradead.org>,
        FBDEV-ML <linux-fbdev@vger.kernel.org>
Date: Wed, 26 Jan 2011 15:07:44 -0800
Subject: RE: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk	upon
 panic
Thread-Topic: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk
	upon panic
Thread-Index: Acu9V440dO+SsReHSVKm3zl0lCSrBQAVaHow
Message-ID: <987664A83D2D224EAE907B061CE93D53019438EABF@orsmsx505.amr.corp.intel.com>
References: <20110125134748.GA10051@laptop>
 <AANLkTinU0KYiCd4p=z+=ojbkeEoT2G+CAYvdRU02KJEn@mail.gmail.com>
 <20110126124954.GC24527@laptop>
In-Reply-To: <20110126124954.GC24527@laptop>
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

>- The latest approach (proposed by Linus) is to forget the disk: jump to
>  real-mode, but display the kernel log in a fancy format (with scroll
>  ups and downs) instead.

A while ago (first Plumbers conference?) someone was talking about
using a 2-d barcode to display the tail of the kernel log & oops
register data - with the plan that you could capture the image with
a cell phone camera, and then get all the oops data without worrying
about transcription errors as you wrote down & re-typed all the hex.

Anyone know what happened to that plan?

-Tony


