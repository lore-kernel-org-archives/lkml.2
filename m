Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab1JBSjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:39:49 -0400
Received: from 1wt.eu ([62.212.114.60]:33381 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab1JBSjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:39:42 -0400
Date: Sun, 2 Oct 2011 20:39:37 +0200
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111002183937.GL18690@1wt.eu>
References: <4E8655CD.90107@zytor.com> <201110021354.57995.rjw@sisk.pl> <4E88A537.4010008@zytor.com> <201110022014.27549.rjw@sisk.pl> <4E88AB2C.60804@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E88AB2C.60804@zytor.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 11:19:24AM -0700, H. Peter Anvin wrote:
> On 10/02/2011 11:14 AM, Rafael J. Wysocki wrote:
> >>
> >> You probably know enough people (including myself) that would be willing
> >> to sign your key over the phone.  That's part of giving yourself
> >> sufficient time.
> > 
> > Well, then I propose that people create two new key pairs instead of
> > just one and take both of them to the KS for signing.  Afterwards, one
> > of them will be used for development and the other one's private key
> > will be kept in a safe place (without any online access), so it can be
> > used readily if the first pair is lost or compromised somehow.
> > 
> > Perhaps the second pair should have a longer life time.
> > 
> 
> Yes, this is actually a very good practice (the long-lived key should be
> a sign-only key, for what it's worth.)  I didn't propose it because I
> thought it would be too much work.
> 
> What do people think?  It might be more important for people who are
> physically isolated.

I'm not opposed to generate a second key, but I don't really understand
how it solves the isolation issue. I'm not used to key signing parties
and am presently in the situation where I don't know whom to ping to
sign my key. The only thing I could do was to sign it with my old key
as you suggested in the initial mail on the subject :-/

So if at least generating a second key can save that hassle for next
time, I'm all in favor of making it, it just takes a few seconds.

Best regards,
Willy

