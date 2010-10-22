Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab0JVKdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 06:33:12 -0400
Received: from mailbox20.lycos.com ([209.202.250.20]:51652 "EHLO
	mailbox20.lycos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab0JVKdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 06:33:11 -0400
Date: Fri, 22 Oct 2010 06:33:04 -0400 (EDT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: Athanasius <link@miggy.org>
Cc: kevin granade <kevin.granade@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <30241116.270781287743584802.JavaMail.root@mail-zbox20.bo3.lycos.com>
In-Reply-To: <5600814.270321287742009359.JavaMail.root@mail-zbox20.bo3.lycos.com>
Subject: Re: On Linux numbering scheme
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.19.146.60]
X-Mailer: Zimbra 5.0 (ZimbraWebClient - FF3.0 (Linux)/5.0.18_GA_3028.CentOS5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 I don't suggest changing it completely per se, I only propose to make
it a bit saner and more comprehensible.

Right now the end user given a kernel release number won't be able to 
say  if his kernel is recent enough or not. The new numbering scheme
makes it  easy to understand when  a particular  kernel was released
and makes it quite obvious to see how old the running kernel is.

What can you say about kernel 2.6.32? Almost nothing.

What can you say about kernel 3.11.3? - it is the third release of
Linux in 2011.

Best wishes,

Artem


----- "Athanasius" <link@miggy.org> wrote:

> On Fri, Oct 22, 2010 at 03:00:06AM +0100, Al Viro wrote:
> > On Thu, Oct 21, 2010 at 07:06:23PM -0500, kevin granade wrote:
> > 
> > > Any particular reason not to continue the date-oriented format
> and
> > > have the third number be the numerical representation of the
> month
> > > rather than an incrementing numbering of the releases?  It would
> still
> > > be monotonically increasing, which is the only requirement,
> right?
> > 
> > Why do we need to change it, anyway?
> 
>   /agree
> 
>   For the most part it's only distribution maintainers that see or
> care
> about the kernel version number anyway.  Anyone else knows what
> they're
> getting into if they compile a kernel themselves, and otherwise is
> more
> likely to say they're using "Linux 10.10" right now ....
> 
>   Having said that I had a lovely suggestion in the last round on
> this
> topic which would allow you to know when a kernel was released just
> from
> its version number :).
> 
> -- 
> - Athanasius = Athanasius(at)miggy.org / http://www.miggy.org/
>                   Finger athan(at)fysh.org for PGP key
> 	   "And it's me who is my enemy. Me who beats me up.
> Me who makes the monsters. Me who strips my confidence." Paula Cole -
> ME
