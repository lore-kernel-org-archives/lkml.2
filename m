Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab2BVKeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 05:34:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39470 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab2BVKeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 05:34:23 -0500
Date: Wed, 22 Feb 2012 11:33:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@alien8.de>, hpa@zytor.com,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        castet.matthieu@free.fr, tglx@linutronix.de, sfr@canb.auug.org.au,
        hpa@linux.intel.com, rjw@sisk.pl
Subject: Re: [PATCH] x86: remove some noise from boot log when starting cpus
Message-ID: <20120222103348.GE30339@elte.hu>
References: <4E53FBBB.7030008@zytor.com>
 <4e540cf271396b4c4@agluck-desktop.sc.intel.com>
 <20120220160804.GC26703@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120220160804.GC26703@x1.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Tue, Aug 23, 2011 at 01:26:26PM -0700, Luck, Tony wrote:
> > Printing the "start_ip" for every secondary cpu is very noisy on a large
> > system - and doesn't add any value. Drop this message.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> This one is still out-of-tree, can we pick it up pls?

Seems rather old - please resubmit and make sure it still works 
as expected, etc.

Thanks,

	Ingo
