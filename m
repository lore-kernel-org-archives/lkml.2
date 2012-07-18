Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab2GRRxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 13:53:11 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46434 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753246Ab2GRRxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 13:53:07 -0400
Message-ID: <1342633985.9551.36.camel@joe2Laptop>
Subject: Re: [PATCH] staging/et131x: fix checkpatch warnings
From: Joe Perches <joe@perches.com>
To: Toshiaki Yamane <yamanetoshi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Einon <mark.einon@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 18 Jul 2012 10:53:05 -0700
In-Reply-To: <CAOTypNSvKEfYVLZ=0sN-U+2xiXBO4So4QkvYyKniEFeqvkqVBg@mail.gmail.com>
References: <1342442513-10488-1-git-send-email-yamanetoshi@gmail.com>
	 <1342573366-8167-1-git-send-email-yamanetoshi@gmail.com>
	 <1342574175.2012.12.camel@joe2Laptop>
	 <CAOTypNSvKEfYVLZ=0sN-U+2xiXBO4So4QkvYyKniEFeqvkqVBg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 20:32 +0900, Toshiaki Yamane wrote:
> Thanks for you reply.
> 
> I will fix netdev_info only, because I don't know if I should use "%p".

OK, fyi: it turns out ps_ring_physaddr and rx_status_bus
are both dma_addr_t so both should be emitted with %ull
and cast to (unsigned long long) or (u64).


