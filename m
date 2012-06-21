Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675Ab2FUASj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 20:18:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43198 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932417Ab2FUASh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 20:18:37 -0400
Message-ID: <4FE2683E.4060707@zytor.com>
Date: Wed, 20 Jun 2012 17:18:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@amd64.org>,
        LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] x86, microcode: Make reload interface per system
References: <20120619024639.GB6186@khazad-dum.debian.net> <4FDFF27C.5000205@zytor.com> <20120619051116.GB31591@aftab.osrc.amd.com> <1340093864.21745.6.camel@twins> <20120619102250.GA787@aftab.osrc.amd.com> <1340101568.21745.37.camel@twins> <20120619182228.GA18816@khazad-dum.debian.net> <4FE0DF9F.10401@zytor.com> <20120620234651.GD4223@khazad-dum.debian.net> <4FE26182.5070107@zytor.com> <20120621000631.GH4223@khazad-dum.debian.net>
In-Reply-To: <20120621000631.GH4223@khazad-dum.debian.net>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 05:06 PM, Henrique de Moraes Holschuh wrote:
> 
> No, because dd if=<whatever> of=/dev/cpu/microcode bs=1M means I have to
> add dd to the initramfs or to busybox, AND it will break the day the
> microcode data file gets bigger than 1M.  And it will be at best very
> annoying to have to special case each vendor to locate the correct
> microcode, etc.
>

No.

The whole point is you won't have to put ANYTHING in your initramfs,
period.  The early microcode blob will be all you need there.

So the only issue left is what to do when you want to update the
microcode in an already running system.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

