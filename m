Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab2BVK5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 05:57:30 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52924 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab2BVK52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 05:57:28 -0500
Date: Wed, 22 Feb 2012 11:57:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@elte.hu>, "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, castet.matthieu@free.fr, tglx@linutronix.de,
        sfr@canb.auug.org.au, hpa@linux.intel.com, rjw@sisk.pl, hpa@zytor.com
Subject: Re: [PATCH] x86: remove some noise from boot log when starting cpus
Message-ID: <20120222105732.GA5176@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@elte.hu>, "Luck, Tony" <tony.luck@intel.com>,
	linux-kernel@vger.kernel.org, castet.matthieu@free.fr,
	tglx@linutronix.de, sfr@canb.auug.org.au, hpa@linux.intel.com,
	rjw@sisk.pl, hpa@zytor.com
References: <4E53FBBB.7030008@zytor.com>
 <4e540cf271396b4c4@agluck-desktop.sc.intel.com>
 <20120220160804.GC26703@x1.osrc.amd.com>
 <20120222103348.GE30339@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120222103348.GE30339@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 11:33:48AM +0100, Ingo Molnar wrote:
> 
> * Borislav Petkov <bp@alien8.de> wrote:
> 
> > On Tue, Aug 23, 2011 at 01:26:26PM -0700, Luck, Tony wrote:
> > > Printing the "start_ip" for every secondary cpu is very noisy on a large
> > > system - and doesn't add any value. Drop this message.
> > > 
> > > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > 
> > This one is still out-of-tree, can we pick it up pls?
> 
> Seems rather old - please resubmit and make sure it still works 
> as expected, etc.

Yeah, I'll leave that to Tony. I could then verify it works although it
is trivial enough and could go in even now.

-- 
Regards/Gruss,
Boris.
