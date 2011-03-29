Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab1C2TDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 15:03:50 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56395 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab1C2TDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 15:03:49 -0400
Date: Tue, 29 Mar 2011 21:03:40 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Fainelli <florian@openwrt.org>, x86@kernel.org
Subject: Re: [GIT pull] irq cleanups for .39
Message-ID: <20110329190340.GA29565@gere.osrc.amd.com>
References: <alpine.LFD.2.00.1103282048370.2774@localhost6.localdomain6>
 <AANLkTintrwhwbyZGxX1Eecg9ZXo+NgRzTwyyMyzt1JGR@mail.gmail.com>
 <alpine.LFD.2.00.1103282210590.2774@localhost6.localdomain6>
 <alpine.LFD.2.00.1103282227510.2774@localhost6.localdomain6>
 <AANLkTin7Uc=LzZdD4Waj8GF24Nzi2ccUL+RLtk+fBc=g@mail.gmail.com>
 <4D922B35.9050107@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D922B35.9050107@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 11:55:49AM -0700, H. Peter Anvin wrote:
> On 03/28/2011 03:05 PM, Linus Torvalds wrote:
> > On Mon, Mar 28, 2011 at 1:29 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >> On Mon, 28 Mar 2011, Thomas Gleixner wrote:
> >>> 2) msg ids are unique and can ge grepped for. also there are archives
> >>>    which allow searching for them.
> >>>
> >>>    http://marc.info?i=alpine.LFD.2.00.1103252150180.31464@localhost6.localdomain6
> >>>
> >>>    http://mid.gmane.org/alpine.LFD.2.00.1103252150180.31464@localhost6.localdomain6
> >>
> >> So perhaps we should add one of those into the LKML-Reference and let
> >> the commit bot extract the thread reference from there.
> > 
> > Yes. That would make it something usable to normal users.
> > 
> 
> My concern with that is that indexing services come and go (and which
> ones that offer indexing by message-id, which is the *only* permanent
> identifier, are even more subject to change), but things that go into
> the git history stays forever.  In IETF terms, the message-id is the
> "resource name" (as in URN), as opposed to the "resource locator" (as in
> URL).
> 
> There is of course the option of running a bounce service on kernel.org,
> as long as the Message-ID is included.

Yes, this would be very useful. For example, marc.info can do something
like that; you simply go and do

http://marc.info/?i=<message-id>

and it finds you the mail messages with that id it has indexed. You can
then browse the whole thread from there.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
