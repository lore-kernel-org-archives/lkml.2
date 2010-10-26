Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599Ab0JZPXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:23:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751123Ab0JZPXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:23:30 -0400
MIME-Version: 1.0
In-Reply-To: <19654.57160.616600.480900@quad.stoffel.home>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
 <19653.55494.240658.165153@quad.stoffel.home> <4CC5DCBB.1070505@kernel.org>
 <AANLkTim5-QDaG3G_8hq3k83csWsdM-4Pt7V92WtmVx3i@mail.gmail.com>
 <20101025205746.GA6568@infradead.org> <AANLkTi=0Yag66SwgqhudZ8atU6LjaXmTX62VmQ+JMmhF@mail.gmail.com>
 <19654.57160.616600.480900@quad.stoffel.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Oct 2010 08:22:31 -0700
Message-ID: <AANLkTinywnaMNSABWTBwTmC5ML9BRTGgU0+YCfZJSkCT@mail.gmail.com>
Subject: Re: [PATCH 01/11] IMA: use rbtree instead of radix tree for inode
 information cache
To: John Stoffel <john@stoffel.org>
Cc: Christoph Hellwig <hch@infradead.org>, "J.H." <warthog9@kernel.org>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        zohar@us.ibm.com, david@fromorbit.com, jmorris@namei.org,
        kyle@mcmartin.ca, hpa@zytor.com, akpm@linux-foundation.org,
        mingo@elte.hu, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 7:01 AM, John Stoffel <john@stoffel.org> wrote:
>
> So the Kconfig should have 'default N' for IMA then?

ALL new features should have "default n" for them. And if you had
actually looked at it, you would see that it already has that ("n" is
the default if no default is listed) _and_ it says

  "If unsure, say N"

in the comments.

So why the hell are people complaining about a patch-series that
_clearly_ improves on the current situation?

And yes, Fedora should never have enabled it. If the distro doesn't
use a feature, it shouldn't be enabled, because it's inevitably just a
source of problems. In this case, I think we should be happy that it
was enabled just because it made people notice the problem, but at the
same time the fact that Fedora enabled it is _not_ justification for
then saying "well, if you enable it and don't use it, it must be
zero-overhead".

If you want zero overhead and you think nobody uses it (and that seems
to be the _only_ logic the people complaining about it keep drumming
on), then DON'T ENABLE IT, FOR CHRISSAKE!

This thread has been a total waste of everybody's time.

Did I miss any actual _constructive_ criticism of the patches? Is
there any reason I shouldn't actually apply them? If there is, I've
lost it in the roar of pointlessness.

                      Linus
