Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab2CLWDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:03:35 -0400
Received: from edge10.ethz.ch ([82.130.75.186]:43678 "EHLO edge10.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757073Ab2CLWDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:03:33 -0400
From: Thomas Rast <trast@inf.ethz.ch>
To: Jonathan Nieder <jrnieder@gmail.com>
CC: Junio C Hamano <gitster@pobox.com>, Willy Tarreau <w@1wt.eu>,
        Greg KH <greg@kroah.com>, Ben Hutchings <ben@decadent.org.uk>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <git@vger.kernel.org>
Subject: Re: [PATCH] git-am: error out when seeing -b/--binary
References: <20120312024948.GB4650@kroah.com> <20120312063027.GB8971@1wt.eu>
	<20120312064855.GB16820@burratino> <20120312085820.GA11569@1wt.eu>
	<20120312152004.GB9380@kroah.com> <20120312152453.GB12405@1wt.eu>
	<87aa3l4vqq.fsf@thomas.inf.ethz.ch> <20120312165703.GB18791@burratino>
	<7vvcm9snko.fsf@alter.siamese.dyndns.org>
	<87399dpk48.fsf@thomas.inf.ethz.ch> <20120312215607.GB11362@burratino>
Date: Mon, 12 Mar 2012 23:03:15 +0100
In-Reply-To: <20120312215607.GB11362@burratino> (Jonathan Nieder's message of
	"Mon, 12 Mar 2012 16:56:07 -0500")
Message-ID: <874ntto4t8.fsf@thomas.inf.ethz.ch>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [188.155.176.28]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Nieder <jrnieder@gmail.com> writes:

> Hm, on second thought, if people are seeing this message, I would
> prefer if they write to the mailing list so we can find out about it.
> So I really would rather see this say
>
> 	--binary)
> 		: ;;
>
> and have "-b" completely unrecognized, without any words in our
> defense except for a note in the release notes mentioning the option's
> removal and that it has been an unadvertised backward-compatibility
> no-op since 1.6.0.

I'd hate doing that, mostly because other projects got me really angry
about similar issues, e.g., 71c020c (Disable asciidoc 8.4.1+ semantics
for `{plus}` and friends, 2009-07-25).

By the time I knew what the problem was, I figured posting anywhere was
useless since the change was already in the wild, and thus needed
working around on our end; and all I could possibly post was an angry
letter saying how unhappy I was about their work.

I didn't, and worked around it.  But that was after a lot of frustrated
investigation.  So I'd rather not do the same to our unlucky users.

-- 
Thomas Rast
trast@{inf,student}.ethz.ch
