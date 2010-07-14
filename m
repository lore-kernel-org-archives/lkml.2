Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab0GNScd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:32:33 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:5668 "EHLO
	VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab0GNScb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:32:31 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz1432N179dNzz1202hzz15d4Rz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L5K8TY-02-MJ2-02
X-M-MSG: 
Date: Wed, 14 Jul 2010 20:32:16 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Stephan Wolf <stephan@letzte-bankreihe.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH] enable readback to get HPET working on ATI SB4x00,
 kernel 2.6.35_rc5
Message-ID: <20100714183216.GC15651@aftab>
References: <4C3DDDFF.5040302@letzte-bankreihe.de>
 <AANLkTim5fAwwhqP2J9pfOqeJACFf0OvK_MMZc1oZb3M4@mail.gmail.com>
 <20100714181152.GB15651@aftab>
 <AANLkTin71FbM5Eh7TDUHN0WvYHA5RubycflTxM5EWlvj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTin71FbM5Eh7TDUHN0WvYHA5RubycflTxM5EWlvj@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, Jul 14, 2010 at 02:17:27PM -0400

> > I'll try to find out which chipsets are actually affected but in the
> > meantime we might want to do a temporary fix by enabling the readback
> > back(!) on all ATI chipsets so that we don't uncover anymore bugs like
> > the one above, hmmm?
> 
> That sounds like the right solution for now, yes.  Rather than make
> the readback quirk depend on one particular SMBUS revision, make it
> happen unconditionally for an AMD northbridge (or is the HPET in the
> SB?

Yeah, its in the southbridge which is part of the chipset. Actually
we'll have to somehow match ATI chipsets only since we have also nVidia
chipsets with AMD cpus in them.

/me goes to meditate a little about it.

> I forget - somebody who knows the details and can test it on a
> machine or two should do the actual patch).

I'll try to cook up something unless someone beats me to it.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

