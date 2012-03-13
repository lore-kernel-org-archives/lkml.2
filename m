Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab2CMPbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 11:31:06 -0400
Received: from edge20.ethz.ch ([82.130.99.26]:7803 "EHLO edge20.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab2CMPbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 11:31:04 -0400
From: Thomas Rast <trast@student.ethz.ch>
To: Jonathan Nieder <jrnieder@gmail.com>
CC: Junio C Hamano <gitster@pobox.com>, Willy Tarreau <w@1wt.eu>,
        Greg KH <greg@kroah.com>, Ben Hutchings <ben@decadent.org.uk>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <git@vger.kernel.org>
Subject: Re: [PATCH] git-am: error out when seeing -b/--binary
References: <20120312064855.GB16820@burratino> <20120312085820.GA11569@1wt.eu>
	<20120312152004.GB9380@kroah.com> <20120312152453.GB12405@1wt.eu>
	<87aa3l4vqq.fsf@thomas.inf.ethz.ch> <20120312165703.GB18791@burratino>
	<7vvcm9snko.fsf@alter.siamese.dyndns.org>
	<87399dpk48.fsf@thomas.inf.ethz.ch> <20120312215607.GB11362@burratino>
	<874ntto4t8.fsf@thomas.inf.ethz.ch> <20120312222227.GC11362@burratino>
Date: Tue, 13 Mar 2012 16:31:00 +0100
In-Reply-To: <20120312222227.GC11362@burratino> (Jonathan Nieder's message of
	"Mon, 12 Mar 2012 17:22:27 -0500")
Message-ID: <87fwdcldqj.fsf@thomas.inf.ethz.ch>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [129.132.153.233]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Nieder <jrnieder@gmail.com> writes:

> 	--binary)
> 		: ;;
> 	-b)
> 		gettextln >&2 "The -b option (a no-op short for --binary) was removed in 1.7.10."
> 		die "$(gettext "Please adjust your scripts.")"
> 		;;
>
> Mentioning deprecation in 1.6.0 in the message left me uneasy because
> we never actually did anything to actively deprecate the option; it
> just has not been needed since 1.4.3 and we stopped advertising it in
> the manpage in 1.6.0.  So I don't like the implication of "this is all
> right because we told you so" --- on the contrary, it is "in practice
> nobody seems to be using this option and we hope nobody will notice
> when we take it away".

Hmm, I had an alternate patch ready in the morning, but Junio beat us to
it and applied the old one to master.

I don't really think it matters enough to apply *another*, so I'll leave
it at that.

-- 
Thomas Rast
trast@{inf,student}.ethz.ch
