Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab1EYLar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 07:30:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35869 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab1EYLaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 07:30:46 -0400
Date: Wed, 25 May 2011 13:30:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision
Message-ID: <20110525113017.GE30983@elte.hu>
References: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
 <20110525065451.GC429@elte.hu>
 <20110525080042.GA27183@liondog.tnic>
 <20110525090501.GA28500@elte.hu>
 <20110525105057.GA21830@gere.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525105057.GA21830@gere.osrc.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> > Sure we have /sys/devices/system/cpu/cpuN/microcode/version, but 
> > that's both privileged to get
> 
> Not only that but you have to load the ucode driver to be able to 
> read it. /proc/cpuinfo looks like the easiest and most generic 
> place.

Indeed, that's a good point - i sometimes boot kernels without the 
microcode driver built in, so then no microcode gets loaded. If i 
report a weird bug then whoever looks at my bug report might notice 
the ancient ucode version number in /proc/cpuinfo.

Thanks,

	Ingo
