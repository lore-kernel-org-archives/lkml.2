Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab0D1XMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 19:12:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752806Ab0D1XMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 19:12:50 -0400
Date: Wed, 28 Apr 2010 16:12:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH v2] - Randomize node rotor used in
 cpuset_mem_spread_node()
Message-Id: <20100428161244.5d351395.akpm@linux-foundation.org>
In-Reply-To: <1272495846.21962.1090.camel@calx>
References: <20100428131158.GA2648@sgi.com>
	<20100428150432.GA3137@sgi.com>
	<20100428154034.fb823484.akpm@linux-foundation.org>
	<1272495846.21962.1090.camel@calx>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010 18:04:06 -0500
Matt Mackall <mpm@selenic.com> wrote:

> > I suspect random32() would suffice here.  It avoids depleting the
> > entropy pool altogether.
> 
> I wouldn't worry about that. get_random_int() touches the urandom pool,
> which will always leave entropy around. Also, Ted and I decided over a
> year ago that we should drop the whole entropy accounting framework,
> which I'll get around to some rainy weekend.

hm, so why does random32() exist?  Speed?
