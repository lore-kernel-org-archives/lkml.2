Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab1JXIBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 04:01:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44272 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab1JXIBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 04:01:22 -0400
Message-ID: <1319443278.2381.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: Vanilla-Kernel 3 - page allocation failure
From: Eric Dumazet <eric.dumazet@gmail.com>
To: p.herz@profihost.ag
Cc: David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        s.priebe@profihost.ag, linux-kernel@vger.kernel.org
Date: Mon, 24 Oct 2011 10:01:18 +0200
In-Reply-To: <4EA51210.9070209@profihost.ag>
References: <4E9D53FF.7090609@profihost.ag> <m2ipnmz49x.fsf@firstfloor.org>
		 <alpine.DEB.2.00.1110181848150.12850@chino.kir.corp.google.com>
		 <4EA506B9.4030604@profihost.ag> <1319439819.2517.38.camel@edumazet-laptop>
	 <4EA51210.9070209@profihost.ag>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 24 octobre 2011 à 09:21 +0200, Philipp Herz - Profihost AG a
écrit :

> does that mean that there was no firmware limitation with kernel 2.6.32 
> or that the tg3 module has any "disable warnings" flag matching 
> __GFP_NOWARN?
> 

There is no __GFP_NOWARN trick on tg3.

We tend to prefer to be notified of a memory problem, instead of
hide ...

By the way, apparently this driver drops the frame and doesnt increase
tx_dropped device counter. A patch will follow.

Could you post your full dmesg ?


