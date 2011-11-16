Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab1KPU0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 15:26:43 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:53275 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab1KPU0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 15:26:42 -0500
Message-ID: <1321475197.3274.0.camel@edumazet-laptop>
Subject: Re: [3.1] Divide by zero in __tcp_select_window()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Simon Kirby <sim@hostway.ca>
Cc: David Miller <davem@davemloft.net>, tglx@linutronix.de,
        netdev@vger.kernel.org, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, davej@redhat.com, schwidefsky@de.ibm.com,
        mingo@elte.hu
Date: Wed, 16 Nov 2011 21:26:37 +0100
In-Reply-To: <20111116195419.GE24411@hostway.ca>
References: <20111108205411.GA23642@hostway.ca>
	 <1320787405.26025.10.camel@edumazet-laptop>
	 <20111114.153608.2064552703690099046.davem@davemloft.net>
	 <1321304216.2719.23.camel@edumazet-laptop>
	 <20111116195419.GE24411@hostway.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 16 novembre 2011 à 11:54 -0800, Simon Kirby a écrit :

> Looks good, thanks! Working on ~25 boxes without issue for >36 hours.
> 
> Simon-
> 
> Tested-by: Simon Kirby <sim@hostway.ca>

Thanks Simon for this feedback.


