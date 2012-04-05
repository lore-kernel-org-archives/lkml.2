Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab2DEWbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:31:52 -0400
Received: from mx11lb.world4you.com ([81.19.149.121]:49829 "EHLO
	mx11lb.world4you.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446Ab2DEWbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:31:49 -0400
X-Greylist: delayed 4529 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Apr 2012 18:31:49 EDT
Subject: Re: [PATCH] Use correct byte-sized register constraint in
 __xchg_op()
From: Thomas Reitmayr <treitmayr@devbase.at>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        leigh123linux@googlemail.com, Dave Jones <davej@redhat.com>
In-Reply-To: <CA+5PVA50Bz2BtDw77yBvQpc9BxGZqyp0_4JeZUY-E_QB0mFZsA@mail.gmail.com>
References: <4F7A3315.501@goop.org>
	 <CA+5PVA4V-u9fVpJYZ==wB+uxxSExbbBk6O60BM+b-v9Mfk+8vQ@mail.gmail.com>
	 <CA+5PVA50Bz2BtDw77yBvQpc9BxGZqyp0_4JeZUY-E_QB0mFZsA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 05 Apr 2012 23:16:03 +0200
Message-ID: <1333660563.8861.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-AV-Do-Run: Yes
X-SA-Exim-Connect-IP: 85.127.18.214
X-SA-Exim-Mail-From: treitmayr@devbase.at
X-SA-Exim-Scanned: No (on mx11lb.world4you.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,
You are right, this bug also affects 3.3 and IMO should be fixed there,
too!
-Thomas

Am Donnerstag, den 05.04.2012, 16:27 -0400 schrieb Josh Boyer:
> On Tue, Apr 3, 2012 at 8:37 PM, Josh Boyer <jwboyer@gmail.com> wrote:
> > On Mon, Apr 2, 2012 at 7:15 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >> x86-64 can access the low half of any register, but i386 can only do
> >> it with a subset of registers.  'r' causes compilation failures on i386,
> >> but 'q' expresses the constraint properly.
> >>
> >> Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
> >> Reported-by: Leigh Scott <leigh123linux@googlemail.com>
> >> Tested-by: Thomas Reitmayr <treitmayr@devbase.at>
> >
> > This should be CC'd to stable, given the bug shows up in 3.3, right?
> 
> Er.. this patch seems to have been lost in limbo.  Is anyone following
> up on it?
> 
> josh
> 


