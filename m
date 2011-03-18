Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab1CRO3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 10:29:24 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:57460 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953Ab1CRO3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 10:29:18 -0400
Subject: Re: known vboxgetty/isdn issue in 2.6.35.3?
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Udo van den Heuvel <udovdh@xs4all.nl>, Karsten Keil <isdn@linux-pingi.de>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Tilman Schmidt <tilman@imap.cc>,
        stable@kernel.org
In-Reply-To: <201103181524.33246.arnd@arndb.de>
References: <4C864143.5090803@xs4all.nl> <201011091115.16351.arnd@arndb.de>
	 <1300398521.16073.60.camel@localhost>  <201103181524.33246.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Mar 2011 15:29:25 +0100
Message-ID: <1300458565.4299.301.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: 87.77.215.94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 18.03.2011, 15:24 +0100 schrieb Arnd Bergmann:
> On Thursday 17 March 2011, Michael Karcher wrote:
> > The same issue happened on our system. Sometimes vboxgetty gets stuck in
> > state D on a debian stable system (2.6.32). I just applied your patch to
> > that kernel and hope the problem went away. Please remind me to report
> > back in one to two weeks if I didn't already report whether the hangs
> > are fixed. Is something except for a test on a productive system missing
> > to get this fix into 32-stable?
> 
> Thanks for the report. You are talking about this patch, right?
> 
> bc10f96757 "isdn: avoid calling tty_ldisc_flush() in atomic context"

Yes, exactly. Sorry for not mentioning it. I did not experience the BUG,
but the hung task, just as in the mail I replied to.

Regards,
  Michael Karcher

