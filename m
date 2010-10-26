Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488Ab0JZSN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 14:13:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42913 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231Ab0JZSNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 14:13:25 -0400
Date: Tue, 26 Oct 2010 19:13:10 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: John Stoffel <john@stoffel.org>, Christoph Hellwig <hch@infradead.org>,
        "J.H." <warthog9@kernel.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, zohar@us.ibm.com, david@fromorbit.com,
        jmorris@namei.org, kyle@mcmartin.ca, hpa@zytor.com,
        akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 01/11] IMA: use rbtree instead of radix tree for inode
 information cache
Message-ID: <20101026181310.GY19804@ZenIV.linux.org.uk>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
 <19653.55494.240658.165153@quad.stoffel.home>
 <4CC5DCBB.1070505@kernel.org>
 <AANLkTim5-QDaG3G_8hq3k83csWsdM-4Pt7V92WtmVx3i@mail.gmail.com>
 <20101025205746.GA6568@infradead.org>
 <AANLkTi=0Yag66SwgqhudZ8atU6LjaXmTX62VmQ+JMmhF@mail.gmail.com>
 <19654.57160.616600.480900@quad.stoffel.home>
 <AANLkTinywnaMNSABWTBwTmC5ML9BRTGgU0+YCfZJSkCT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinywnaMNSABWTBwTmC5ML9BRTGgU0+YCfZJSkCT@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 08:22:31AM -0700, Linus Torvalds wrote:

> If you want zero overhead and you think nobody uses it (and that seems
> to be the _only_ logic the people complaining about it keep drumming
> on), then DON'T ENABLE IT, FOR CHRISSAKE!
> 
> This thread has been a total waste of everybody's time.
> 
> Did I miss any actual _constructive_ criticism of the patches? Is
> there any reason I shouldn't actually apply them? If there is, I've
> lost it in the roar of pointlessness.

FWIW, I'm OK with that.  My general opinion about the quality and
usefulness of security/* is a separate story, but if we are stuck
with that shit in the tree, let's at least trim down what can be
trimmed down.
