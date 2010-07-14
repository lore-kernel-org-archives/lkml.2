Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab0GNTcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:32:54 -0400
Received: from www.tglx.de ([62.245.132.106]:45525 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757438Ab0GNTcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:32:52 -0400
Date: Wed, 14 Jul 2010 21:32:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Borislav Petkov <borislav.petkov@amd.com>,
        Stephan Wolf <stephan@letzte-bankreihe.de>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH] enable readback to get HPET working on ATI SB4x00, kernel
 2.6.35_rc5
In-Reply-To: <AANLkTin71FbM5Eh7TDUHN0WvYHA5RubycflTxM5EWlvj@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1007142130380.3321@localhost.localdomain>
References: <4C3DDDFF.5040302@letzte-bankreihe.de> <AANLkTim5fAwwhqP2J9pfOqeJACFf0OvK_MMZc1oZb3M4@mail.gmail.com> <20100714181152.GB15651@aftab> <AANLkTin71FbM5Eh7TDUHN0WvYHA5RubycflTxM5EWlvj@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010, Linus Torvalds wrote:

> On Wed, Jul 14, 2010 at 11:11 AM, Borislav Petkov
> <borislav.petkov@amd.com> wrote:
> >
> > I'll try to find out which chipsets are actually affected but in the
> > meantime we might want to do a temporary fix by enabling the readback
> > back(!) on all ATI chipsets so that we don't uncover anymore bugs like
> > the one above, hmmm?
> 
> That sounds like the right solution for now, yes.  Rather than make

Ack.

> the readback quirk depend on one particular SMBUS revision, make it
> happen unconditionally for an AMD northbridge (or is the HPET in the
> SB? I forget - somebody who knows the details and can test it on a
> machine or two should do the actual patch).

It's in the SB. Need to figure out how to cover all ATI chipsets and
not blindly imposing this on any other chipset which is used with AMD
cpus.

Thanks,

	tglx
