Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972Ab0JZPyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:54:40 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:50047 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab0JZPyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:54:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19654.63880.124969.849547@quad.stoffel.home>
Date: Tue, 26 Oct 2010 11:53:44 -0400
From: "John Stoffel" <john@stoffel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: John Stoffel <john@stoffel.org>, Christoph Hellwig <hch@infradead.org>,
        "J.H." <warthog9@kernel.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, zohar@us.ibm.com, david@fromorbit.com,
        jmorris@namei.org, kyle@mcmartin.ca, hpa@zytor.com,
        akpm@linux-foundation.org, mingo@elte.hu, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 01/11] IMA: use rbtree instead of radix tree for inode
 information cache
In-Reply-To: <AANLkTinywnaMNSABWTBwTmC5ML9BRTGgU0+YCfZJSkCT@mail.gmail.com>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
	<19653.55494.240658.165153@quad.stoffel.home>
	<4CC5DCBB.1070505@kernel.org>
	<AANLkTim5-QDaG3G_8hq3k83csWsdM-4Pt7V92WtmVx3i@mail.gmail.com>
	<20101025205746.GA6568@infradead.org>
	<AANLkTi=0Yag66SwgqhudZ8atU6LjaXmTX62VmQ+JMmhF@mail.gmail.com>
	<19654.57160.616600.480900@quad.stoffel.home>
	<AANLkTinywnaMNSABWTBwTmC5ML9BRTGgU0+YCfZJSkCT@mail.gmail.com>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Linus" == Linus Torvalds <torvalds@linux-foundation.org> writes:

Linus> On Tue, Oct 26, 2010 at 7:01 AM, John Stoffel <john@stoffel.org> wrote:
>> 
>> So the Kconfig should have 'default N' for IMA then?

Linus> ALL new features should have "default n" for them. And if you
Linus> had actually looked at it, you would see that it already has
Linus> that ("n" is the default if no default is listed) _and_ it says

Linus>   "If unsure, say N"

Linus> in the comments.

Yes, I did look at it.  I just didn't see a default listed for the
overall IMA feature, while sub-feature do have a 'default N' option
set.  And so my confusion.  My fault for not understanding Kconfig
defaults better.

John
