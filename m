Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab2CLVNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 17:13:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab2CLVNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 17:13:47 -0400
Date: Mon, 12 Mar 2012 17:13:33 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Jones <davej@redhat.com>, Yang Bai <hamo.by@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>, kernel@tesarici.cz,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: inode->i_wb_list corruption.
Message-ID: <20120312211333.GB20204@zod.bos.redhat.com>
References: <20120307072608.GA24087@localhost>
 <20120307104240.GB18658@quack.suse.cz>
 <CAO_0yfNt2jgiTPZn5NkwBAjQZtk+377gG71d6QOuXQrDHjdkEg@mail.gmail.com>
 <20120309145713.GA21543@redhat.com>
 <20120309151951.GA30160@redhat.com>
 <CAO_0yfMYOOTvRg9=8_eYP09o0BpzSEk=8vqgNk_vV_u3-biAYA@mail.gmail.com>
 <20120309180015.GA3862@redhat.com>
 <868vj97d20.fsf@sumi.keithp.com>
 <20120309201934.GN17489@zod.bos.redhat.com>
 <861up175su.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861up175su.fsf@sumi.keithp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 02:44:49PM -0800, Keith Packard wrote:
> <#part sign=pgpmime>
> On Fri, 9 Mar 2012 15:19:34 -0500, Josh Boyer <jwboyer@redhat.com> wrote:
> 
> > Is the VT-d issue something in the hardware itself, or do you mean if
> > you have it enabled in the kernel?  We've had the intel IOMMU disabled
> > by default in the Fedora kernels for a while now.  At least since before
> > 3.2 was released.
> 
> I don't know for sure; David Woodhouse gave a scary presentation
> yesterday that makes me unsure of what happens when IOMMU is disabled in
> the kernel, given that much of the hardware is setup by the BIOS.

Is that presentation something that could be shared?  I have to say,
hearing that doesn't really inspire confidence in either the IOMMU or
the kernel.

josh
