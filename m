Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab2DCC36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 22:29:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58041 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab2DCC34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 22:29:56 -0400
Subject: Re: [PATCH] phonet: Check input from user before allocating
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: remi@remlab.net, levinsasha928@gmail.com, remi.denis-courmont@nokia.com,
        davej@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120402.222300.1137842205135530387.davem@davemloft.net>
References: <1333417997.18626.1.camel@edumazet-glaptop>
	 <20120402.215911.1929019308299701014.davem@davemloft.net>
	 <1333419304.18626.5.camel@edumazet-glaptop>
	 <20120402.222300.1137842205135530387.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Apr 2012 04:29:52 +0200
Message-ID: <1333420192.18626.8.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 22:23 -0400, David Miller wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Tue, 03 Apr 2012 04:15:04 +0200
> 
> > Any idea of a representative benchmark in dgram af_unix ?
> 
> Maybe you could try to make bw_unix from lmbench use
> SOCK_DGRAM? :-)
> 

Yes, I also converted hackbench to SOCK_DGRAM and change its DATASIZE
from 100 to 10000 bytes per message.

Thanks


