Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab1COJIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:08:19 -0400
Received: from uranus.manitu.net ([217.11.48.8]:36187 "EHLO uranus.manitu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab1COJIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:08:10 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Mar 2011 05:08:10 EDT
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] can: wrong index used in inner loop
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Tue, 15 Mar 2011 10:02:25 +0100
From: wg <wg@grandegger.com>
Cc: <roel.kluin@gmail.com>, <socketcan-core@lists.berlios.de>,
        <netdev@vger.kernel.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <20110314.144743.232749141.davem@davemloft.net>
References: <4D768917.9040605@gmail.com>
 <20110314.144743.232749141.davem@davemloft.net>
Message-ID: <edb90b03bb533480b6a5cea0e0c0822d@grandegger.com>
User-Agent: RoundCube Webmail/0.2-beta
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011 14:47:43 -0700 (PDT), David Miller
<davem@davemloft.net> wrote:
> From: roel <roel.kluin@gmail.com>
> Date: Tue, 08 Mar 2011 20:52:55 +0100
> 
>> Index i was already used in the outer loop.
>> 
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> 
> CAN maintainers, could you please review and ACK patches in a timely
> manner,
> especially utterly trivial bug fixes like this one here?
> 
> That's largely what I've been waiting for, a simple sign of life from
the
> listed maintainers for these files.

OK, will try to react fast next time.

> Anyways, no use waiting any longer, applied, thanks Roel.

Thanks,

Wolfgang.

