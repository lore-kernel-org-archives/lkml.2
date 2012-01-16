Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab2APJtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:49:41 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:56665 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896Ab2APJtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:49:40 -0500
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed
 address is invalid"
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Keith Packard <keithp@keithp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20120116093133.GB15333@elte.hu>
References: <1323648762-2148-1-git-send-email-keithp@keithp.com>
	 <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com>
	 <867h22jwj1.fsf@sumi.keithp.com> <4EE575E3.7090206@zytor.com>
	 <8639cqjvyn.fsf@sumi.keithp.com>
	 <1323684083.3669.15.camel@mfleming-mobl1.ger.corp.intel.com>
	 <86sjkpiw8i.fsf@sumi.keithp.com>
	 <1323962963.314.14.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1326705757.3629.18.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20120116093133.GB15333@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jan 2012 09:49:27 +0000
Message-ID: <1326707367.3629.26.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-16 at 10:31 +0100, Ingo Molnar wrote:
> * Matt Fleming <matt@console-pimps.org> wrote:
> 
> > Ping?
> 
> Would be nice to have testing from Keith as your fix looks more 
> attractive than the plain revert.
> 
> I could queue up the fix blindly and do a double revert if it 
> breaks, but i already strongly depleted my problematic-tree 
> quota for this cycle, so i'd rather have a nice Tested-by tag 
> from Keith ... ;-)

Sorry, I should have been more verbose here. What I was really asking
was whether Keith has had chance to test this patch. A Tested-by tag is
essential - I really don't want to be responsible for a problematic
tree ;-)

> Failing that i guess we'll have to do the revert, and re-try the 
> original commit with your fix merged into it.

The revert is already in Linus' tree as e1ad783b12ec "Revert "x86, efi:
Calling __pa() with an ioremap()ed address is invalid", so at least
we've got some time to get this patch right.

-- 
Matt Fleming, Intel Open Source Technology Center

