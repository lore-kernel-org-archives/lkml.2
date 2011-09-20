Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab1ITIfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 04:35:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:59814 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab1ITIfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 04:35:36 -0400
Date: Tue, 20 Sep 2011 10:35:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@amd64.org>
cc: LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "Rosenfeld, Hans" <Hans.Rosenfeld@amd.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Mike Travis <travis@sgi.com>
Subject: Re: [patch 0/3] x86: cache_info: Bugfix and cleanups AMD_NB
 related
In-Reply-To: <20110919214457.GA15223@aftab>
Message-ID: <alpine.LFD.2.02.1109201035080.2723@ionos>
References: <20110723212603.517924252@linutronix.de> <20110919214457.GA15223@aftab>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011, Borislav Petkov wrote:

> On Sun, Jul 24, 2011 at 05:46:07AM -0400, Thomas Gleixner wrote:
> > The following series fixes a kfree() problem in the cache_info code
> > and cleans up the shadow struct mess and gets rid of the atomic
> > allocation in the smp function call.
> > 
> > Thanks,
> > 
> > 	tglx
> > ---
> >  include/asm/amd_nb.h         |    6 ++
> >  kernel/cpu/intel_cacheinfo.c |  121 ++++++++++++++-----------------------------
> >  2 files changed, 47 insertions(+), 80 deletions(-)
> 
> /me wonders whatever happened to those?

queued in tip and they should be in next as well.
