Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900Ab0JZPbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:31:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab0JZPbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:31:36 -0400
Subject: Re: [PATCH 01/11] IMA: use rbtree instead of radix tree for inode
 information cache
From: Eric Paris <eparis@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: John Stoffel <john@stoffel.org>, Christoph Hellwig <hch@infradead.org>,
        "J.H." <warthog9@kernel.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        zohar@us.ibm.com, david@fromorbit.com, jmorris@namei.org,
        kyle@mcmartin.ca, hpa@zytor.com, akpm@linux-foundation.org,
        mingo@elte.hu, viro@zeniv.linux.org.uk
In-Reply-To: <AANLkTinywnaMNSABWTBwTmC5ML9BRTGgU0+YCfZJSkCT@mail.gmail.com>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
	 <19653.55494.240658.165153@quad.stoffel.home> <4CC5DCBB.1070505@kernel.org>
	 <AANLkTim5-QDaG3G_8hq3k83csWsdM-4Pt7V92WtmVx3i@mail.gmail.com>
	 <20101025205746.GA6568@infradead.org>
	 <AANLkTi=0Yag66SwgqhudZ8atU6LjaXmTX62VmQ+JMmhF@mail.gmail.com>
	 <19654.57160.616600.480900@quad.stoffel.home>
	 <AANLkTinywnaMNSABWTBwTmC5ML9BRTGgU0+YCfZJSkCT@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 11:30:02 -0400
Message-ID: <1288107002.2655.102.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 08:22 -0700, Linus Torvalds wrote:

> Did I miss any actual _constructive_ criticism of the patches? Is
> there any reason I shouldn't actually apply them? If there is, I've
> lost it in the roar of pointlessness.

I think dchinner had some comments on what he might like to see in the
long run to further improve the situation, but I don't think anything he
requested or commented on precludes this series from being applied...

-Eric

