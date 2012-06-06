Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979Ab2FFVxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:53:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:52262 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab2FFVxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:53:03 -0400
Date: Wed, 6 Jun 2012 23:52:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@amd64.org>
cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Chen Gong <gong.chen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 1/6] x86: mce: Create devices in CPU_UP_PREPARE
In-Reply-To: <20120606214219.GC6841@aftab.osrc.amd.com>
Message-ID: <alpine.LFD.2.02.1206062351460.3086@ionos>
References: <20120606211746.693649684@linutronix.de> <20120606212334.513459224@linutronix.de> <alpine.LFD.2.02.1206062337310.3086@ionos> <20120606214219.GC6841@aftab.osrc.amd.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012, Borislav Petkov wrote:

> On Wed, Jun 06, 2012 at 11:38:11PM +0200, Thomas Gleixner wrote:
> > On Wed, 6 Jun 2012, Thomas Gleixner wrote:
> > 
> > > This makes the treshold_cpu_callback for AMD actually work and makes
> > > the code symetric vs. teardown.
> > 
> > Ignore that. I sent out the wrong version of this lot. Sorry for the noise
> 
> By this you mean the chunk at the end of 5/6, right?
> 
> There's a chunk touching amd_64_threshold_cpu_callback...

Both 1/6 and 5/6 are wrong. That's a leftover from a previous
iteration. About to send the fixed version.

