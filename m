Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab1CNKuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:50:46 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44308 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab1CNKup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 06:50:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=t7qa4Z9g6roZtre20XpnJs+k4UzC9aUIbOYxDsCXGlvmu+aY2sGMO/QVpfERC8ml0F
         hh5A9ouDqhc2OQDmrnEjbIYmtzhPSGYU2aG4wg66xEqxLyA1tyb5bLdGM7QYPNymYPtO
         fLbiCSGLXJRc0SWj96D+pa6gpxIddo/BNg6WY=
MIME-Version: 1.0
In-Reply-To: <20110314104131.GG6275@bubble.grove.modra.org>
References: <20110311165802.GA3508@intel.com>
	<4D7A64670200007800035F4C@vpn.id2.novell.com>
	<AANLkTikG8wa1Em0bEUddbYpYs2TzFFTDb95qWFJ3xSbv@mail.gmail.com>
	<4D7DE39302000078000362E6@vpn.id2.novell.com>
	<20110314095534.GB18058@elte.hu>
	<20110314104131.GG6275@bubble.grove.modra.org>
Date: Mon, 14 Mar 2011 12:50:44 +0200
X-Google-Sender-Auth: hD3NsGgE4z1xtutr6DULkXhuaw0
Message-ID: <AANLkTi=3AiLaw5Gnis8Ha4eRXirk0s-Cnk2zzN12YDpH@mail.gmail.com>
Subject: Re: PATCH: Add --size-check=[error|warning]
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Jan Beulich <JBeulich@novell.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, binutils@sourceware.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Modra <amodra@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Mon, Mar 14, 2011 at 12:41 PM, Alan Modra <amodra@gmail.com> wrote:
> On Mon, Mar 14, 2011 at 10:55:34AM +0100, Ingo Molnar wrote:
>> The thing is, it is absolutely, breath-takingy incompetent for
>
> kernel developers to write such poor asm!  And not notice the error
> for 4 years!  Oh, and the binutils developers to write such a poor
> assembler in the first place.  ;-)
>
> Seriously, you are complaining because something is fixed??
>
>> The correct solution is to turn it into a warning as me and others have suggested.
>
> I disagree.  The whole world is not the linux kernel.  I think HJ is
> bending over backwards to even offer a switch that turns the error
> into a warning.

So what do you suggest that testers who want to, say, build old Linux
kernel versions with new binutils do?

                        Pekka
