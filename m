Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab1HXJiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 05:38:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35671 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab1HXJis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 05:38:48 -0400
Message-ID: <4E54C6A3.3070606@kernel.org>
Date: Wed, 24 Aug 2011 12:38:43 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-next@vger.kernel.org
Subject: Re: linux next: Native Linux KVM tool inclusion request
References: <1314044960.3668.9.camel@lappy> <20110823003925.GA30253@infradead.org> <CAOJsxLEgm_-N6297kHqSjFLCtX-Vd204S=+4Q=+GW9HYiWj1eg@mail.gmail.com> <4E54B6E2.2030203@redhat.com> <4E54C210.1030204@kernel.org> <4E54C55A.7010109@redhat.com>
In-Reply-To: <4E54C55A.7010109@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/11 12:33 PM, Avi Kivity wrote:
> Well, just trashing /home/penberg would be bad too, no? (my recent 
> experience indicates it's not that catastrophic - anything important 
> sits on a server somewhere and the local data is just a cache).

Sure. We actually are planning something like this:

   Private to guest:

   /dev
   /etc
   /home
   /proc
   /sys
   /var

   Shared from host rootfs:

   /bin
   /lib
   /sbin
   /usr

   Full host rootfs mounted at:

   /host/

And no, we're not planning to boot full distro init. The only thing we
really want in addition to /bin/sh is to enable networking.

                                 Pekka
