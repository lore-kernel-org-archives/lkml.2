Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab0K2R7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 12:59:50 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51241 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab0K2R7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 12:59:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TikNL9itYeM9//i6Gca4++MdNdABeyu5d9uM2mZ5WaxtFoRyr/d2Krbzi8xVyj/AGH
         sEQfk0rUvkcRJIlzVQZVgDG6fuRAJpiDLJJG+2X1tebh1K4BKQ0nPBJ9Itf9+6sxVnZ0
         faQITUR7jW+1fCE4p6wIOBTPaTnmW8JVmnNZc=
Subject: Re: [PATCH v2 0/4] kthread: NUMA aware kthread_create_on_cpu()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org, tj@kernel.org,
        rusty@rustcorp.com.au, tony.luck@intel.com, fenghua.yu@intel.com
In-Reply-To: <20101129.093942.104054089.davem@davemloft.net>
References: <20101129090510.GA15763@basil.fritz.box>
	 <1291023532.3435.29.camel@edumazet-laptop>
	 <1291043604.3435.969.camel@edumazet-laptop>
	 <20101129.093942.104054089.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 18:59:43 +0100
Message-ID: <1291053583.3435.1269.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 29 novembre 2010 à 09:39 -0800, David Miller a écrit :
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Mon, 29 Nov 2010 16:13:23 +0100
> 
> > Note : compiled and tested on x86_32 and x86_64 only, but these patches
> > take care of other arches as well.
> > 
> > Cc: linux-arch@vger.kernel.org 
> > 
> > Thanks for your feedback Andi !
> 
> I'm fine with these changes:
> 
> Acked-by: David S. Miller <davem@davemloft.net>
> 
> Since the majority is non-networking it is pretty clear
> that someone other than me should integrate these patches.
> :-)

Sure !

I was thinking Andrew was the guy to carry this patch series, once
things settle down of course...

Thanks


