Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab1A1MnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 07:43:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35433 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab1A1MnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 07:43:06 -0500
Subject: Re: [PATCH V10 01/15] time: Introduce timekeeping_inject_offset
From: Peter Zijlstra <peterz@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Cochran <richardcochran@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>, Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
In-Reply-To: <201101281305.37370.arnd@arndb.de>
References: <cover.1296124770.git.richard.cochran@omicron.at>
	 <1296154099.2855.162.camel@work-vm>
	 <20110128070800.GA3225@riccoc20.at.omicron.at>
	 <201101281305.37370.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 13:43:50 +0100
Message-ID: <1296218630.15234.334.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 13:05 +0100, Arnd Bergmann wrote:
> On Friday 28 January 2011, Richard Cochran wrote:
> > I would like to get to the bottom of this. Here is what I did:
> > 
> >    1. Saved your patch to disk in mbox format using Mutt.
> >    2. git am
> >    3. ... rebase, rebase, rebase, ...
> >    4. git format-patch [options] 1234..abcd
> >    5. Edit cover letter
> >    6. for x in 00*; do mutt -H $x; done
> > 
> > Git format-patch places the "From: John Stultz <john.stultz@linaro.org>"
> > line with the other mail headers, and so I guess mutt just faithfully
> > preserves this.
> > 
> > I don't like having to remember to fix this manually. There must be a
> > better way...
> 
> The problem is step 6. The output of git format-patch does not work when
> sending with mutt. The easiest solution is to send with git send-email,
> which does the same as mutt -H, but gets it right.

I use: formail -s sendmail -t < patches.mbox, but then, I use quilt mail
to generate the mbox, not git.

