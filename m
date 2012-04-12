Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762723Ab2DLUmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:42:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:38578 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749Ab2DLUmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:42:24 -0400
Date: Thu, 12 Apr 2012 22:42:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@linux.intel.com>
cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        =?ISO-8859-15?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: Re: [v3.4-rc1] ACPI regression bisected
In-Reply-To: <4F872C7B.6000106@linux.intel.com>
Message-ID: <alpine.LFD.2.02.1204122241460.2542@ionos>
References: <CADDKRnBpGr=yzDftChA3xiaK9gK4D4UDV6HJiw8hcMo6159+Cw@mail.gmail.com> <20120402235412.GD16303@tassilo.jf.intel.com> <alpine.LFD.2.02.1204031001510.2542@ionos> <CADDKRnAOqfxTjrCp4E5eKFJvVTu6s0xF3Ca3jRJavFkyGpYLmQ@mail.gmail.com>
 <alpine.LFD.2.02.1204121055200.2542@ionos> <20120412142904.GA4130@srcf.ucam.org> <alpine.LFD.2.02.1204121903250.2542@ionos> <alpine.LFD.2.02.1204121907330.2542@ionos> <4F872C7B.6000106@linux.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012, Andi Kleen wrote:
> > > I feared that. So now is the question whether there is a way to mask
> > > the interrupt at the "device" level.
> 
> Probably not. Len?
> 
> > If not, I could be persuaded to provide a mechanism to force thread
> > all interrupts which are on that line, if there's a good argument to
> > do so.
> 
> Hmm, we could probably just use a work queue for this instead. I guess i drank
> the threaded
> interrupt kool aid too much when I did the patch :-)
> 
> I'll switch over to a workqueue.
> 
> Meanwhile the patch can be just reverted. The patch that needed it (delays in
> EC access to
> work around buggy Acer EC) was not merged by  Len so far, so there's nothing
> in tree right
> now that relies on the thread.
> 
> For 3.4 I think reverting is the right approach.

Ack.
