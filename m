Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab2FSDbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 23:31:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48921 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab2FSDbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 23:31:47 -0400
Message-ID: <4FDFF27C.5000205@zytor.com>
Date: Mon, 18 Jun 2012 20:31:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Borislav Petkov <bp@amd64.org>, LKML <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] x86, microcode: Make reload interface per system
References: <1339521996.31548.95.camel@twins> <20120612173506.GB4802@aftab.osrc.amd.com> <20120613010413.GA28174@khazad-dum.debian.net> <20120613065119.GB15661@aftab.osrc.amd.com> <20120613123649.GA26012@khazad-dum.debian.net> <20120613161139.GA18450@aftab.osrc.amd.com> <20120615123749.GC6083@aftab.osrc.amd.com> <1339764161.2559.63.camel@twins> <20120615125240.GD6083@aftab.osrc.amd.com> <20120615165231.GA9169@aftab.osrc.amd.com> <20120619024639.GB6186@khazad-dum.debian.net>
In-Reply-To: <20120619024639.GB6186@khazad-dum.debian.net>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 07:46 PM, Henrique de Moraes Holschuh wrote:
> 
> It is a pity this one is much harder to backport to 3.2 and 3.0.  I'd
> really like to have the new interface there.  But it looks good, and we
> will support the new /sys/devices/system/cpu/microcode/reload sysfs node
> in Debian for the benefit of anyone using a newer kernel than the
> distro's (which will be based on 3.2).
> 
> So, fwiw, you have my:
> Acked-by-unimportant-person: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> 

I have to admit to being slightly questioning to the whole "sysfs
trigger, request_firmware" interface... it seems royally backwards to me
(it makes sense for the initial firmware load, I guess, but that is
better done early.)

Either way I don't have a hugely strong preference.

	-hpa

