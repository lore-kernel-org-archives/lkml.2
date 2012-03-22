Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab2CVFde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 01:33:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:40027 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab2CVFdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 01:33:31 -0400
Message-ID: <1332394386.2982.75.camel@pasglop>
Subject: Re: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Thu, 22 Mar 2012 16:33:06 +1100
In-Reply-To: <CA+55aFz-pyBHa73zkbkub4czwnU+k4_qKzBEaAGvi66MBBUTpQ@mail.gmail.com>
References: <1332377206.2982.60.camel@pasglop>
	 <CA+55aFz-pyBHa73zkbkub4czwnU+k4_qKzBEaAGvi66MBBUTpQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 19:02 -0700, Linus Torvalds wrote:
> On Wed, Mar 21, 2012 at 5:46 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> >
> > Here's the powerpc batch for this merge window. It is going to be a bit
> > more nasty than usual as in touching things outside of arch/powerpc
> > mostly due to the big iSeriesectomy :-) We finally got rid of the bugger
> > (legacy iSeries support) which was a PITA to maintain and that nobody
> > really used anymore.
> >
> > Here are some of the highlights:
> 
> Ok, so this conflicted a bit with the generalized irq-domain stuff
> from Grant Likely, and while I tried to fix it up I can't even
> compile-test the end result, so you really need to verify my merge and
> perhaps send me fixups. Ok?
> 
> Especially the sysdev/mpic.c resolution needs somebody who knows the
> code to verify. Added Grant and Kyle explicitly to the cc..

I tested a few machines (ppc32 dual G4, a G5, some P6 and P7 machines)
and it seems to be all good. Thanks !

Cheers,
Ben.
 

