Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab1CAO4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 09:56:55 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42335 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380Ab1CAO4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:56:53 -0500
Date: Tue, 1 Mar 2011 15:56:49 +0100
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>,
        Michal Marek <mmarek@suse.cz>, torvalds@linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, linux-kbuild@vger.kernel.org,
        bp@amd64.org
Subject: Re: [PATCH -v4] kbuild: Add extra gcc checks
Message-ID: <20110301145649.GB28609@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	=?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>,
	Michal Marek <mmarek@suse.cz>, torvalds@linux-foundation.org,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>, linux-kbuild@vger.kernel.org,
	bp@amd64.org
References: <20110221110322.GA9819@liondog.tnic>
 <201102282207.33489.arnd@arndb.de>
 <20110228213134.GA10825@liondog.tnic>
 <201103011235.00389.arnd@arndb.de>
 <20110301132050.GA24374@cr0.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110301132050.GA24374@cr0.private>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 09:20:50PM +0800, Américo Wang wrote:
> On Tue, Mar 01, 2011 at 12:35:00PM +0100, Arnd Bergmann wrote:
> >On Monday 28 February 2011, Borislav Petkov wrote:
> >> My intention was not to have multiple levels of warnings because then
> >> you have to go and enable the different levels and have to remember
> >> which level you used last, etc, etc.
> >
> >I wasn't suggesting more than two, so the two would have very distinct
> >definitions:
> >
> >W=1: Warnings that we would like to fix all over the tree, patches to
> >     remove these are always welcome and you can build the entire kernel
> >     with it. Once they are all fixed, we can make the warnings the default.
> >
> >W=2: Warnings that we know we don't always want to fix, meant for what
> >     you describe here -- you build a single file and decide what to
> >     do based on common sense. 
> >
> 
> Right, this makes sense. Borislav, could you implement this?

Yeah, I could try to come up with a sensible choice for mutual-exclusive
sets of -W.. options. Any preferences?

-- 
Regards/Gruss,
Boris.
