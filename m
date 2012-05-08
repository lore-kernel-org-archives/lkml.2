Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab2EHVPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 17:15:05 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:51165 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab2EHVPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 17:15:04 -0400
Date: Tue, 8 May 2012 23:11:13 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>
Subject: Re: [PATCH 02/23] x86, realmode: realmode.bin infrastructure
Message-ID: <20120508211112.GA12167@merkur.ravnborg.org>
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com> <1336501366-28617-3-git-send-email-jarkko.sakkinen@intel.com> <20120508185349.GA12013@merkur.ravnborg.org> <4FA9709F.6020700@linux.intel.com> <4FA97ED3.1060105@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA97ED3.1060105@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 01:15:15PM -0700, H. Peter Anvin wrote:
> On 05/08/2012 12:14 PM, H. Peter Anvin wrote:
> >>
> >> How much is needed to avoid this misuse of kernel-internal build rules?
> >> This was and is an ugly hack.
> >>
> > 
> > It is more or less the same as for arch/x86/boot and other things.  If
> > there are better ways to do it suggestions are very much appreciated.
> > 
> > However, it is a bit of a tricky bit because we need *some* of the bits
> > of the target compiler configuration and some not (this is the same as
> > arch/x86/boot etc.)  It is not "pure target" but it's also most
> > definitely not host.
> > 
> 
> Anyway... to answer your direct question: all of that would have been
> required anyway.  In therms of build rules the overall patchset is
> pretty much a lateral move from arch/x86/kernel/acpi/rm to
> arch/x86/realmode/rm.  That doesn't mean we couldn't do it
> better/centralize/etc; however, none of this is new and would be a
> separate change.

Agreed.
It just hurst my stummack big-time when KBUILD_CFLAGS are manupulated
in a "random" Makefile.
Last time we looked at this I failed to come up with something better.

	Sam
