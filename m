Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab2BHV0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:26:23 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:61074 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757785Ab2BHV0U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:26:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAG4TOxMVmEe3KiDuaO6ZWq0vNchi1Mrf=mr2RSNJY2oXX0hD+Q@mail.gmail.com>
References: <1311923731.7845.25.camel@edumazet-laptop>
	<1328181135.2279.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CAG4TOxMVmEe3KiDuaO6ZWq0vNchi1Mrf=mr2RSNJY2oXX0hD+Q@mail.gmail.com>
Date: Wed, 8 Feb 2012 23:26:19 +0200
Message-ID: <CAJZOPZJtXGq36Hx5BQAc2Q7znErJ-Uaiqs-DaJQ=jCSy49uTiQ@mail.gmail.com>
Subject: Re: [PATCH] IB/ehca: use kthread_create_on_node
From: Or Gerlitz <or.gerlitz@gmail.com>
To: Roland Dreier <roland@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Sean Hefty <sean.hefty@intel.com>,
        linux-rdma@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 2, 2012 at 7:08 PM, Roland Dreier <roland@kernel.org> wrote:
> On Thu, Feb 2, 2012 at 3:12 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:

>> Any news on this patch ?

> Sorry, just dropped it in the shuffle.  I'll get it into 3.4, thanks.

Roland,

I noted that you typically use the for-next branch of the infiniband
tree for fixes during
the 1 < kernN-rc < (say) 6 time and for features during (kernN-rc > 6)
till kern(N+1)-rc1

This means that the window of time when features are actually accepted
into your tree is kind of very limited. Would it be possible to
maintain two branches: for-next and (say) rc-fixes, such that
practically patches are reviewed/accepted to for-next at almost all
times?

BTW I see that networking and scsi maintainers use two trees
(net/net-next) and (scsi-misc/scsi-rc-fixes), maybe it would be eaiser
for you go this way?

Or.
