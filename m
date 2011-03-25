Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab1CYPl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:41:59 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60420 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab1CYPl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:41:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=kepstin.ca; s=google;
        h=subject:from:to:cc:date:in-reply-to:references:content-type
         :x-mailer:content-transfer-encoding:message-id:mime-version;
        b=Al3x+x4HybAHUP+Heks2DWcRvgg9w+R5Z7pEJrGw170gku9O8urC6qGV7CE6GxYjC1
         U2ddOwvXJeJQA1nGZQy/ErhtQrYyGYT6LlKBX/bqRCL8laFnumdRkkS4ULZewjze2P3c
         cFZ6szRYDvkEejlsTaMfempQBuOdatP1jdvcE=
Subject: Re: [PATCH] x86 APM: delete Linux kernel APM support
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Len Brown <lenb@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
        x86@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 25 Mar 2011 11:41:54 -0400
In-Reply-To: <alpine.LFD.2.02.1103241929450.16085@x980>
References: <alpine.LFD.2.02.1103232321070.3848@x980>
	 <20110324154505.934a56a0.sfr@canb.auug.org.au>
	 <alpine.LFD.2.02.1103240336590.4529@x980>
	 <alpine.LFD.2.02.1103240414450.4529@x980> <20110324083959.GE30812@elte.hu>
	 <alpine.LFD.2.02.1103241929450.16085@x980>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.90 
Content-Transfer-Encoding: 7bit
Message-ID: <1301067716.2053.6.camel@ayu>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 19:49 -0400, Len Brown wrote:
> > > Microsoft was able to delete APM from Windows in 2006
> > > with the release of Windows Vista. [...]
> > 
> > Does Windows XP still support it?
> 
> yes, and so does Red Hat Linux 9.

> > While i'm not a fan of APM at all, this removal is a tad fast IMHO.
> >
> > Beyond the lack of a upstream-visible feature-removal-schedule entry, we still 
> > have an Arcnet driver which hardware was obsoleted by Ethernet in the late 80s, 
> > and we still have i486 support and those are *much* older than APM.
> 
> How would you like to write i486 specific code for the latest kernel
> and test it on i486 hardware, honestly?

Hmm, that reminds me: I should try a newer kernel on my 486 some time,
it's still running 2.6.25. I'm actually quite honestly surprised that
the modern libata drivers include code for and fully support my old
vesa-bus IDE controller! (X has been less friendly, they dropped support
for the graphics chipset during the Xfree86 4 development--but I mostly
use this box headless.)

-- 
Calvin Walton <calvin.walton@kepstin.ca>

