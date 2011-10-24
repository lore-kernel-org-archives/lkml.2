Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab1JXIaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 04:30:05 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45326 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab1JXIaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 04:30:03 -0400
Message-ID: <1319444998.2381.4.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: Vanilla-Kernel 3 - page allocation failure
From: Eric Dumazet <eric.dumazet@gmail.com>
To: p.herz@profihost.ag
Cc: David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        s.priebe@profihost.ag, linux-kernel@vger.kernel.org
Date: Mon, 24 Oct 2011 10:29:58 +0200
In-Reply-To: <4EA51F9B.7090806@profihost.ag>
References: <4E9D53FF.7090609@profihost.ag> <m2ipnmz49x.fsf@firstfloor.org>
			 <alpine.DEB.2.00.1110181848150.12850@chino.kir.corp.google.com>
			 <4EA506B9.4030604@profihost.ag>
	 <1319439819.2517.38.camel@edumazet-laptop>	 <4EA51210.9070209@profihost.ag>
	 <1319443278.2381.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4EA51F9B.7090806@profihost.ag>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 24 octobre 2011 à 10:19 +0200, Philipp Herz - Profihost AG a
écrit :
> Currently i can not provide any further information, 'cause server has 
> been restarted.
> 
> What exactly are you looking for?

A dmesg for 2.6.32 is OK, I look for :

- memory layout (tg3 has workarounds for 4G crossing),
- and exact tg3 chip, tg3 messages...



