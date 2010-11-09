Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab0KIVAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:00:37 -0500
Received: from thunk.org ([69.25.196.29]:52794 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab0KIVAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:00:36 -0500
Date: Tue, 9 Nov 2010 16:00:30 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] include/linux/kernel.h: Move logging bits to
 include/linux/logging.h
Message-ID: <20101109210030.GI3099@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Joe Perches <joe@perches.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1289281110-8559-1-git-send-email-joe@perches.com>
 <AANLkTime8YvyHysZF5sX6V2mXWJ0FUtdecpVFgRGqYm6@mail.gmail.com>
 <1289328235.1823.108.camel@Joe-Laptop>
 <AANLkTi=rTw+ByhdGc9prjwvqt_TT=NmOYzEjns1LffLC@mail.gmail.com>
 <1289330276.1823.125.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289330276.1823.125.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 11:17:56AM -0800, Joe Perches wrote:
> 
> Differences in logging.h to original kernel.h
> were done for cleanliness and checkpatch.

Yet another reason why I detest mindless use of checkpatch.  And as a
maintainer, I balance the value of code movement patches in particular
against how it breaks other people's patches, and how unless I do
*very* careful review, people can sneak in changes that could either
(a) break code accidentally, or even (b) introduce security holes
deliberately.  (i.e., if I was in charge of the cyber warfare division
of some large nation state, a really obvious way of trying to insert
vulnerabilities into code is to send "cleanup" patches that move code
around, and introduce some subtle buffer overrun or other
security change.)

As a result, I spend extra time reviewing patches that move code
around, and I **really** dislike patches that try to do any kind of
cleanup (checkpatch.pl or otherwise) at the same time as they move
code around.

	       	    	    	      	   - Ted
