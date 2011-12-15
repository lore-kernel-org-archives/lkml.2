Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384Ab1LOTDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:03:31 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39994 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759358Ab1LOTD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:03:28 -0500
X-Sasl-enc: t0ejs8jJZlmFezaF5yjTqCsOGmHmFldrnuih5kuo1ic0 1323975807
Date: Thu, 15 Dec 2011 11:02:32 -0800
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: printk() vs tty_io
Message-ID: <20111215190232.GE18791@kroah.com>
References: <1323804803.9082.40.camel@twins>
 <CA+55aFxNWiRQ1CkifhgcnnBqBa-xRNdM9Ze6bnxhsYd4ZYPg6A@mail.gmail.com>
 <20111214104308.14d0500c@pyramind.ukuu.org.uk>
 <1323860206.28489.35.camel@twins>
 <20111214140527.GA18080@thunk.org>
 <1323872631.28489.37.camel@twins>
 <CA+55aFwu+oSPtqfN+bS3_fHXWU+VMd5BGhNd=J4MjuAJZT+fTQ@mail.gmail.com>
 <1323943005.18942.18.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323943005.18942.18.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 10:56:45AM +0100, Peter Zijlstra wrote:
> [ Personally I think USB serial console is insane, if you really need
> something like that use the ehci-dbgp thing, that at least has a chance
> of working. ]

USB serial console was written on a drunken bet and the fact that it
even works at all constantly amazes me.  I know people use it as that's
all they have access to, but for "real" debugging, you are right, you
need the ehci-debug device to ensure that you really get the oops
messages the system sends out.

thanks,

greg k-h
