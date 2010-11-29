Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab0K2Xb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 18:31:59 -0500
Received: from ozlabs.org ([203.10.76.45]:50563 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab0K2Xb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 18:31:57 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2 0/4] kthread: NUMA aware kthread_create_on_cpu()
Date: Tue, 30 Nov 2010 10:01:55 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic-pae; KDE/4.5.1; i686; ; )
Cc: David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, andi@firstfloor.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        netdev@vger.kernel.org, tj@kernel.org, tony.luck@intel.com,
        fenghua.yu@intel.com
References: <20101129090510.GA15763@basil.fritz.box> <20101129.093942.104054089.davem@davemloft.net> <1291053583.3435.1269.camel@edumazet-laptop>
In-Reply-To: <1291053583.3435.1269.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011301001.55968.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 04:29:43 am Eric Dumazet wrote:
> Le lundi 29 novembre 2010 à 09:39 -0800, David Miller a écrit :
> > From: Eric Dumazet <eric.dumazet@gmail.com>
> > Date: Mon, 29 Nov 2010 16:13:23 +0100
> > 
> > > Note : compiled and tested on x86_32 and x86_64 only, but these patches
> > > take care of other arches as well.
> > > 
> > > Cc: linux-arch@vger.kernel.org 
> > > 
> > > Thanks for your feedback Andi !
> > 
> > I'm fine with these changes:
> > 
> > Acked-by: David S. Miller <davem@davemloft.net>
> > 
> > Since the majority is non-networking it is pretty clear
> > that someone other than me should integrate these patches.
> > :-)
> 
> Sure !
> 
> I was thinking Andrew was the guy to carry this patch series, once
> things settle down of course...

I'm happy with that.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.
