Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab2FTXtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:49:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42926 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758582Ab2FTXts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:49:48 -0400
Message-ID: <4FE26182.5070107@zytor.com>
Date: Wed, 20 Jun 2012 16:49:22 -0700
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
References: <20120615125240.GD6083@aftab.osrc.amd.com> <20120615165231.GA9169@aftab.osrc.amd.com> <20120619024639.GB6186@khazad-dum.debian.net> <4FDFF27C.5000205@zytor.com> <20120619051116.GB31591@aftab.osrc.amd.com> <1340093864.21745.6.camel@twins> <20120619102250.GA787@aftab.osrc.amd.com> <1340101568.21745.37.camel@twins> <20120619182228.GA18816@khazad-dum.debian.net> <4FE0DF9F.10401@zytor.com> <20120620234651.GD4223@khazad-dum.debian.net>
In-Reply-To: <20120620234651.GD4223@khazad-dum.debian.net>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 04:46 PM, Henrique de Moraes Holschuh wrote:
> 
> Well, it makes the kernel tell us what (amd/intel/whatever) firmware it
> wants, and requires (after patching) a simple echo 1 >foo to activate.  It
> is also harmless if activated without updated firmware in place.
> 
> /dev/cpu/microcode requires special software (or a dd with bs>=file size),
> since it borks if userspace breaks a microcode into two write() syscalls,
> and requires detection of the cpu vendor.  Very annoying.
> 

Yeah, because dd is such an exotic piece of software...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

