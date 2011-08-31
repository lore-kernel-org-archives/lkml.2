Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1HaT4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 15:56:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45937 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752546Ab1HaT4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 15:56:53 -0400
Date: Wed, 31 Aug 2011 20:54:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
Message-ID: <20110831205439.1a0c94da@lxorguk.ukuu.org.uk>
In-Reply-To: <4E5E8F04.9030303@zytor.com>
References: <4E582577.2060805@zytor.com>
	<201108311839.52863.arnd@arndb.de>
	<CA+55aFwVJ71=cLsUqMaJ-eGP0doPGBhrse9r++hkbiNYNx5Zjg@mail.gmail.com>
	<1397886.AAh13B9r2H@wuerfel>
	<4E5E8F04.9030303@zytor.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Aug 2011 12:44:04 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 08/31/2011 12:18 PM, Arnd Bergmann wrote:
> >>
> >> You do realize that there are probably quite a lot of programs that
> >> depend on signed time_t because they really do care about dates before
> >> 1970?
> > 
> > Yes, it already occurred to me after I had written the above that we
> > really want it to be signed, especially to allow a meaningful conversion
> > at least one-way between 32 and 64 bit time_t values.
> > 
> 
> The only reason I mentioned redefining 32-bit time_t as unsigned was for
> *legacy ABIs*.

But if you redefine it then it's not a legacy ABI any more - its a new
ABI. Might as well just cause the pain. 64bit has already done much of
the cleaning up.
