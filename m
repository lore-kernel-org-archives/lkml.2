Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966490Ab2EOTEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 15:04:47 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55453 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966394Ab2EOTEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 15:04:45 -0400
Message-ID: <1337108679.3005.34.camel@dabdike.lan>
Subject: Re: Linux 3.4-rc7
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        John David Anglin <dave.anglin@bell.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mikulas Patocka <mpatocka@redhat.com>, stepanm@codeaurora.org,
        Thomas Gleixner <tglx@linutronix.de>, deller@gmx.de,
        dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
        eike-kernel@sf-tec.de, linux-parisc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 15 May 2012 20:04:39 +0100
In-Reply-To: <4FB2A43D.7090005@linux.vnet.ibm.com>
References: <CA+55aFzsygnrJwLUPV8Vg4RPmwxXLuY-uo70fBLEZR8+barT5A@mail.gmail.com>
	 <4FB011E7.1000604@linux.vnet.ibm.com>
	 <BLU0-SMTP22F4864AE1F54838C150D797150@phx.gbl>
	 <4FB0197F.6010000@linux.vnet.ibm.com>
	 <BLU0-SMTP85D30AAA2BF2CF07B1039897150@phx.gbl>
	 <BLU0-SMTP4CED805E93EF3D8DA2198971A0@phx.gbl>
	 <CA+55aFy1TGH07Ng-nbmWs2N8=kfFMCMosF1TsevLcHhCpWL-LQ@mail.gmail.com>
	 <4FB2A090.6060404@linux.vnet.ibm.com>
	 <CA+55aFwLayGtrWJw1bN9+wwy4NqeyV2Bwkt5VWJVF-a=eGkDcQ@mail.gmail.com>
	 <4FB2A43D.7090005@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 00:15 +0530, Srivatsa S. Bhat wrote:
> On 05/16/2012 12:12 AM, Linus Torvalds wrote:
> 
> > On Tue, May 15, 2012 at 11:29 AM, Srivatsa S. Bhat
> > <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> >>>
> >>> Can somebody send the final patches with proper subject lines etc,
> >>> instead of hiding them in unrelated threads? I hate picking up patches
> >>> that I don't personally know from the middle of some random thread.
> >>>
> >>
> >>
> >> Okay, here they are:
> > 
> > What part of "with proper subject lines" didn't you get?
> > 
> > Look at the subject line. Look at how you put the patch in the middle
> > of an old thread that was about something totally different.
> > 
> > This was *exactly* what I complained about. I don't want patches like this.
> > 
> 
> 
> Oops! Sorry about that! I will resend in a separate thread with appropriate
> subject line.

If it helps, I've already imported it to the parisc fixes tree with a
corrected subject line.  We still have this and the PA1.1 fix, when I
can confirm it's actually the complete fix for the boot panics.

James


