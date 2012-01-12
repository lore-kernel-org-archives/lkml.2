Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab2ALQOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 11:14:40 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63105 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab2ALQOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 11:14:38 -0500
Message-ID: <1326384875.2950.25.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] rcu: avoid checking for constant
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>, laijs@cn.fujitsu.com,
        manfred@colorfullife.com, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Date: Thu, 12 Jan 2012 17:14:35 +0100
In-Reply-To: <alpine.LNX.2.01.1201121657001.24875@frira.zrqbmnf.qr>
References: <1326345104-6919-1-git-send-email-jengelh@medozas.de>
	 <20120112071431.GA1896@leaf>
	 <alpine.LNX.2.01.1201121018430.31943@frira.zrqbmnf.qr>
	 <20120112095257.GA2441@leaf>
	 <alpine.LNX.2.01.1201121106040.17330@frira.zrqbmnf.qr>
	 <1326365659.2950.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <alpine.LNX.2.01.1201121154530.21275@frira.zrqbmnf.qr>
	 <20120112152912.GB2419@linux.vnet.ibm.com>
	 <alpine.LNX.2.01.1201121657001.24875@frira.zrqbmnf.qr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 12 janvier 2012 à 17:08 +0100, Jan Engelhardt a écrit :

> Maybe, maybe naah. The kernel relying on gcc's -O2 mode to do constant 
> value analysis through and into inline functions does not sound too 
> great. The compiler could change on the next moonphase. In fact, one 
> can't use clang -O2 because of this. With my patch, one can again use 
> clang -O2 [with respect to kfree_rcu].

Unless whole kernel can be compiled with -O0, its really some noise.



