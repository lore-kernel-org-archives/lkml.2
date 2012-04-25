Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab2DYILf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 04:11:35 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46025 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2DYILb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 04:11:31 -0400
Date: Wed, 25 Apr 2012 10:11:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <bp@amd64.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Liu, Jinsong" <jinsong.liu@intel.com>, tony.luck@intel.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        torvalds@linux-foundation.org
Subject: Re: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
Message-ID: <20120425081125.GA19849@gmail.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com>
 <20120421041454.GA29704@phenom.dumpdata.com>
 <20120421104502.GB17005@aftab.osrc.amd.com>
 <m2aa21o7pk.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2aa21o7pk.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Borislav Petkov <bp@amd64.org> writes:
> 
> > Because, if you'd hooked into it, just imagine one fine day, when we
> > remove mcelog support, what screaming the xen people will be doing when
> > mcelog doesn't work anymore.
> 
> That's simple. /dev/mcelog is a widely used user space ABI 
> [...]

*COUGH* *SPLUTTER* *LAUGH*.

Thanks for making my day with the self-serving exaggeration of 
the year.

In truth /dev/mcelog is one of the crappiest ABIs Linux has - 
full stop. As a result it's barely used by anyone who can avoid 
it - its main usecase is the utility you wrote for it and some 
enterprise folks who desperately need that data and don't care 
how they get it. The mcelog user-space utility sucks too, 
understandably.

Nevertheless we probably have to keep the ABI around until a 
truly better replacement is out there (the RAS daemon for 
example) and mcelog usage eclipses to obscurity, but by all 
means we want to limit its further spreading /dev/mcelog to 
areas it has not polluted yet ...

Thanks,

	Ingo
