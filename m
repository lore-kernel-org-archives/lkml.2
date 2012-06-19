Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab2FSWT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 18:19:58 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:43515 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab2FSWT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 18:19:57 -0400
Date: Wed, 20 Jun 2012 00:19:56 +0200
From: Borislav Petkov <bp@amd64.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Borislav Petkov <bp@amd64.org>, LKML <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] x86, microcode: Make reload interface per system
Message-ID: <20120619221956.GB5996@aftab.osrc.amd.com>
References: <20120613065119.GB15661@aftab.osrc.amd.com>
 <20120613123649.GA26012@khazad-dum.debian.net>
 <20120613161139.GA18450@aftab.osrc.amd.com>
 <20120615123749.GC6083@aftab.osrc.amd.com>
 <1339764161.2559.63.camel@twins>
 <20120615125240.GD6083@aftab.osrc.amd.com>
 <20120615165231.GA9169@aftab.osrc.amd.com>
 <20120619024639.GB6186@khazad-dum.debian.net>
 <20120619050325.GA31591@aftab.osrc.amd.com>
 <20120619185736.GD18816@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120619185736.GD18816@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 03:57:36PM -0300, Henrique de Moraes Holschuh wrote:

> I was wondering whether it would be worthwhile to backport the new ABI
> for the Debian 3.2 kernel or not. Probably not.

Nope, changing released kernels' ABI is a no-no.

> Backporting to 3.2 and 3.0 is straigthforward, however it will look
> nasty as one has to "inappropriately touch" the cpu sysdev class to
> get the attribute group directly connected to /sys/devices/system/cpu.
>
> I did notice there were no stable backports of the error unwind during
> module init, but that one is a very rarely used codepath. Maybe worth
> to backport a fix to stable, though.

Yeah, stable rules say we only backport regression fixes and although
missing error unwind is a small regression, I've never heard of it
causing trouble.

> Well, my ack is unimportant in the "this is not an area of the kernel
> I have any authority to ack things" sense. But we don't have a
> "I-wanna-that-by:" or even a "Thumbs-up-by:"...

Which reminds me, I forgot to add your tags to the patches, sorry.

@hpa: Would you please add Henrique's {Tested,Acked}-by tags to the
patches? Thanks.

> > Thanks for review and testing, I'll send out the patches soon.
> 
> Thank you for addressing these issues and writing the patches!

Sure, absolutely! :-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
