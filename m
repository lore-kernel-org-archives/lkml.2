Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab0JNV0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:26:36 -0400
Received: from borg.medozas.de ([188.40.89.202]:55059 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072Ab0JNV0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:26:36 -0400
Date: Thu, 14 Oct 2010 23:26:34 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, agruen@suse.de, davem@davemloft.net,
        andi@firstfloor.org
Subject: Re: Process to push changes to include/linux/types.h
In-Reply-To: <20101014125458.9e51ac58.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.2.01.1010142324400.31442@obet.zrqbmnf.qr>
References: <1287084892.3367.18.camel@dhcp231-212.rdu.redhat.com> <20101014125458.9e51ac58.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2010-10-14 21:54, Andrew Morton wrote:
>
>> A patch was posted a bit ago by agruen which made a change to
>> include/linux/types.h changing aligned_u64 to __aligned_u64 and exposing
>> this new type to userspace.
>> [...]
>> I'm a little stuck as to the right path forward.  I normally would have
>> had no qualms about adding __aligned_u64 to types.h in the notification
>> tree and pushing it to Linus next go-round and then the net tree could
>> convert and potentially drop the old aligned_u64 type (but again that
>> would be outside the net tree).  Since Dave isn't willing to add the
>> type and I don't want to get called too many bad names
>
>The usual approach here is someone sends it to me and I send it to
>Linus ;)

We tinkered on types.h before, with the change originating in the Netfilter
subtree, and nobody, not even Dave, complained. (See v2.6.24-6165-gc82a5cb)
