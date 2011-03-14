Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab1CNKlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:41:44 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62587 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab1CNKlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 06:41:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=BB05a5pPBY4xtlYXZeEpIUo55sXjpmQa1/SQtaRtlYl/L1Wx/T0PY43OTOL5P99hU9
         bZtoZjo/h3lWaJZuelxD7n1by6U0O/RuPepHI+iAiGwvc8/rzawvvdOahii47XZqqpqY
         cTN8y7zhaG9uuk7UtvH/1zVShYqU4Cd3Wn8OU=
Date: Mon, 14 Mar 2011 21:11:31 +1030
From: Alan Modra <amodra@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Beulich <JBeulich@novell.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        binutils@sourceware.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PATCH: Add --size-check=[error|warning]
Message-ID: <20110314104131.GG6275@bubble.grove.modra.org>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	Jan Beulich <JBeulich@novell.com>, "H.J. Lu" <hjl.tools@gmail.com>,
	binutils@sourceware.org, linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20110311165802.GA3508@intel.com>
 <4D7A64670200007800035F4C@vpn.id2.novell.com>
 <AANLkTikG8wa1Em0bEUddbYpYs2TzFFTDb95qWFJ3xSbv@mail.gmail.com>
 <4D7DE39302000078000362E6@vpn.id2.novell.com>
 <20110314095534.GB18058@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314095534.GB18058@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 10:55:34AM +0100, Ingo Molnar wrote:
> The thing is, it is absolutely, breath-takingy incompetent for

kernel developers to write such poor asm!  And not notice the error
for 4 years!  Oh, and the binutils developers to write such a poor
assembler in the first place.  ;-)

Seriously, you are complaining because something is fixed??

> The correct solution is to turn it into a warning as me and others have suggested.

I disagree.  The whole world is not the linux kernel.  I think HJ is
bending over backwards to even offer a switch that turns the error
into a warning.

-- 
Alan Modra
Australia Development Lab, IBM
