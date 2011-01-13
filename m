Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab1AMDpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 22:45:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49263 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1AMDpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 22:45:44 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=SB9xQvl_uYIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=MMvfFCmRXeTaKv6HUzsA:9 a=BPjpTt5oItHNL-GRmEhUmA-sRHsA:4 a=PUjeQqilurYA:10 a=LI9Vle30uBYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: on builds/randconfigs (was: [PATCH -next] thermal: depends on
 NET)
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-acpi@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Linus <torvalds@linux-foundation.org>
In-Reply-To: <20110113114446.cba7a01f.sfr@canb.auug.org.au>
References: <20101213163607.0b0a7c3a.sfr@canb.auug.org.au>
	 <alpine.LFD.2.02.1101121257580.18873@x980>
	 <20110112131800.d64c1a86.akpm@linux-foundation.org>
	 <201101122224.54330.rjw@sisk.pl> <alpine.LFD.2.02.1101121654000.19754@x980>
	 <20110113114446.cba7a01f.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 12 Jan 2011 22:45:40 -0500
Message-ID: <1294890340.26623.383.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-13 at 11:44 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> On Wed, 12 Jan 2011 16:58:26 -0500 (EST) Len Brown <lenb@kernel.org> wrote:
> >
> > Kconfig select needs to be fixed so that it is not possible to
> > select something if that something's dependencies are not met.
> 
> So, should the config step fail if such a thing is attempted, or just not
> honour the "select"?
> 
> BTW, Linus asked me to investigate the alternative of having "select"
> (recursively) automatically set the dependencies if they are not already
> set ...
> 

What happens if you have foo depends on bar || fib ?

Do you automatically enable bar and fib?

-- Steve


