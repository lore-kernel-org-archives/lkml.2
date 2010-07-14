Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab0GNSSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:18:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754220Ab0GNSSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:18:04 -0400
MIME-Version: 1.0
In-Reply-To: <20100714181152.GB15651@aftab>
References: <4C3DDDFF.5040302@letzte-bankreihe.de>
	<AANLkTim5fAwwhqP2J9pfOqeJACFf0OvK_MMZc1oZb3M4@mail.gmail.com>
	<20100714181152.GB15651@aftab>
Date: Wed, 14 Jul 2010 11:17:27 -0700
Message-ID: <AANLkTin71FbM5Eh7TDUHN0WvYHA5RubycflTxM5EWlvj@mail.gmail.com>
Subject: Re: [PATCH] enable readback to get HPET working on ATI SB4x00, kernel 
	2.6.35_rc5
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Stephan Wolf <stephan@letzte-bankreihe.de>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Andreas Herrmann <andreas.herrmann3@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 11:11 AM, Borislav Petkov
<borislav.petkov@amd.com> wrote:
>
> I'll try to find out which chipsets are actually affected but in the
> meantime we might want to do a temporary fix by enabling the readback
> back(!) on all ATI chipsets so that we don't uncover anymore bugs like
> the one above, hmmm?

That sounds like the right solution for now, yes.  Rather than make
the readback quirk depend on one particular SMBUS revision, make it
happen unconditionally for an AMD northbridge (or is the HPET in the
SB? I forget - somebody who knows the details and can test it on a
machine or two should do the actual patch).

Thomas?

                Linus
