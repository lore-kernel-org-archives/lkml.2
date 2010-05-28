Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab0E1Ix1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 04:53:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36961
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028Ab0E1Ix0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 04:53:26 -0400
Date: Fri, 28 May 2010 01:53:34 -0700 (PDT)
Message-Id: <20100528.015334.229733519.davem@davemloft.net>
To: mingo@elte.hu
Cc: eric.dumazet@gmail.com, torvalds@linux-foundation.org, tglx@linutronix.de,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: boot crash in arp_error_report()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100528082440.GA4168@elte.hu>
References: <20100527.161011.104042698.davem@davemloft.net>
	<20100528080531.GA9893@elte.hu>
	<20100528082440.GA4168@elte.hu>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 28 May 2010 10:24:40 +0200

> Preliminary testing shows that Eric's patch solves the problem.
> 
> Tested-by: Ingo Molnar <mingo@elte.hu>

Thanks a lot for testing Ingo.
