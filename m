Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966607Ab2ERTLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 15:11:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39826 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964976Ab2ERTLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 15:11:11 -0400
Date: Fri, 18 May 2012 12:11:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: Re: Urgent: x86-32 and GNU ld 2.22.52.0.1
Message-ID: <20120518191103.GA11715@kroah.com>
References: <4FB67146.9080804@zytor.com>
 <CAMe9rOqp5AUNL7Oeb2fz=nFq6Z-=hdFg_T2kc+jwkYtzOKJv9g@mail.gmail.com>
 <CAMe9rOp-UoQFBvvorZA8-jBXk5JobkVa+trUH7ihHLxNyqMuWw@mail.gmail.com>
 <4FB67697.50904@zytor.com>
 <CAMe9rOqAJGemCiAebtYczqvV62J_cyZcZDDtkFZyLHPKZg1xqQ@mail.gmail.com>
 <4FB67CD6.8040103@zytor.com>
 <CAMe9rOpUoj_1TM0NOqVX31aHEez3_i9v6f7_zkGeM8SZ+XDxyQ@mail.gmail.com>
 <4FB67E20.6080300@zytor.com>
 <20120518184121.GA3371@kroah.com>
 <4FB69A75.30507@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB69A75.30507@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 11:52:37AM -0700, H. Peter Anvin wrote:
> On 05/18/2012 11:41 AM, Greg KH wrote:
> > On Fri, May 18, 2012 at 09:51:44AM -0700, H. Peter Anvin wrote:
> >> On 05/18/2012 09:50 AM, H.J. Lu wrote:
> >>>
> >>> A small testcase:
> >>>
> >>
> >> Right, but we can equally well just let the postprocessing tool throw an
> >> error.
> > 
> > That would probably be the best thing to do right now, and we can
> > backport that to the stable kernel releases also to ensure they work
> > properly.
> > 
> 
> So the question is: do you want to simply take the patches from the
> trampoline branch (which are reasonably tested) or do a minimal backport
> which only throws an error (which would not be)?

All 4 of those patches?  They look simple and "sane" to me.  They solve
the problem even with the "buggy" binutils, right?  If so, sure, I'll
take those after they land in Linus's tree, which I'm guessing will be
for 3.5-rc1, right?

thanks,

greg k-h
