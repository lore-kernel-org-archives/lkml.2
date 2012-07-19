Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab2GSSXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 14:23:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab2GSSW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 14:22:57 -0400
Date: Thu, 19 Jul 2012 14:22:36 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
Message-ID: <20120719182235.GG8469@zod.bos.redhat.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <20120713210240.GG1707@redhat.com>
 <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com>
 <20120719152618.GD16873@home.goodmis.org>
 <20120719154521.GC8469@zod.bos.redhat.com>
 <1342714088.12353.33.camel@gandalf.stny.rr.com>
 <20120719171918.GD8469@zod.bos.redhat.com>
 <1342722036.26179.40.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342722036.26179.40.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 08:20:36PM +0200, Paul Bolle wrote:
> On Thu, 2012-07-19 at 13:19 -0400, Josh Boyer wrote:
> > kconfig already spits out warnings for symbols being selected that
> > don't exist.
> 
> Does it? Since when does it do that? Or do you mean select in a more
> general way (not just meaning Kconfig's "select" statement)?

I believe Alan was more correct than me when he said it was 'make
oldconfig' that produced the warnings.

josh
