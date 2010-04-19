Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab0DSTCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 15:02:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752861Ab0DSTCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 15:02:46 -0400
Date: Mon, 19 Apr 2010 12:00:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: David Miller <davem@davemloft.net>, tilman@imap.cc,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: tip: origin tree build failure, [patch] fix isdn/gigaset build
 failure
In-Reply-To: <alpine.LFD.2.00.1004191112550.14500@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004191200050.14500@i5.linux-foundation.org>
References: <20100419.003857.260094283.davem@davemloft.net> <20100419172731.GA4358@elte.hu> <20100419.103304.35342954.davem@davemloft.net> <20100419180520.GA9244@elte.hu> <alpine.LFD.2.00.1004191112550.14500@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 Apr 2010, Linus Torvalds wrote:
> 
> Maybe add the #include <linux/sched.h> into gigaset.h, instead of 
> common.c?

This compiled for me, although the only thing I tried was just turning all 
the gigaset options to 'y'. Maybe some other config doesn't work. So I 
committed it as likely to fix things.

		Linus
