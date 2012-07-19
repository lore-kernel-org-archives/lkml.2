Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750767Ab2GSQMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 12:12:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17821 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2GSQME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 12:12:04 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=BHldU6QlfDUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=ZDp-9K7_6mKwiUnpIukA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342714322.12353.36.camel@gandalf.stny.rr.com>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Date: Thu, 19 Jul 2012 12:12:02 -0400
In-Reply-To: <CA+55aFzTq2CNxPa3X+N=biFgifrmWbeWQJZLVFAFdySWXQCKXg@mail.gmail.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
	 <20120713210240.GG1707@redhat.com>
	 <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com>
	 <20120719152618.GD16873@home.goodmis.org>
	 <CA+55aFzTq2CNxPa3X+N=biFgifrmWbeWQJZLVFAFdySWXQCKXg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-19 at 08:43 -0700, Linus Torvalds wrote:
> On Thu, Jul 19, 2012 at 8:26 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > Side note, and this is for the 1%. If you want a true minconfig for your
> > system, ktest can do that for you.
> 
> Try it, it's actually much harder than it seems. Like allmodconfig, it
> handles the minimum hardware well, but it tends to handle the subtle
> issues really badly.
> 
> Many config options cause *very* subtle failures that are almost
> impossible to see. Like firewalls not loading correctly (and leaving
> the machine completely open), or just stuff that you didn't happen to
> test (USB sticks, printers, certain programs) not working. Not having
> the right audit options will make things still "work", but you'll get
> warnings at bootup, and who knows what that causes etc etc.
> 
> These kinds of things are exactly why I'd like to have a distro config.

This is why it was more of a side note, and for the 1%. If there's
things you have tests for, to confirm that they work, you could add
those to the TEST option, and the config generated will guarantee to fix
them.

But as you stated, there's lots of subtle things that can go wrong. I
was just posting this as a plug for ktest ;-)

For what you want, I think having the distro supply
a /usr/share/Linux/Kconfig that the linux build system can use would be
very helpful.

-- Steve


