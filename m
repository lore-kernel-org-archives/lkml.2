Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408Ab2ERSl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 14:41:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35026 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759097Ab2ERSlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 14:41:25 -0400
Date: Fri, 18 May 2012 11:41:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: Re: Urgent: x86-32 and GNU ld 2.22.52.0.1
Message-ID: <20120518184121.GA3371@kroah.com>
References: <4FB67146.9080804@zytor.com>
 <CAMe9rOqp5AUNL7Oeb2fz=nFq6Z-=hdFg_T2kc+jwkYtzOKJv9g@mail.gmail.com>
 <CAMe9rOp-UoQFBvvorZA8-jBXk5JobkVa+trUH7ihHLxNyqMuWw@mail.gmail.com>
 <4FB67697.50904@zytor.com>
 <CAMe9rOqAJGemCiAebtYczqvV62J_cyZcZDDtkFZyLHPKZg1xqQ@mail.gmail.com>
 <4FB67CD6.8040103@zytor.com>
 <CAMe9rOpUoj_1TM0NOqVX31aHEez3_i9v6f7_zkGeM8SZ+XDxyQ@mail.gmail.com>
 <4FB67E20.6080300@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB67E20.6080300@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 09:51:44AM -0700, H. Peter Anvin wrote:
> On 05/18/2012 09:50 AM, H.J. Lu wrote:
> > 
> > A small testcase:
> > 
> 
> Right, but we can equally well just let the postprocessing tool throw an
> error.

That would probably be the best thing to do right now, and we can
backport that to the stable kernel releases also to ensure they work
properly.

thanks,

greg k-h
