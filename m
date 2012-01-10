Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab2AJFDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 00:03:23 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:36503 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab2AJFDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 00:03:22 -0500
Message-ID: <1326171798.6638.4.camel@edumazet-laptop>
Subject: Re: [BUG] kernel freezes with latest tree
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 10 Jan 2012 06:03:18 +0100
In-Reply-To: <1326171444.6638.3.camel@edumazet-laptop>
References: <1326171444.6638.3.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 10 janvier 2012 à 05:57 +0100, Eric Dumazet a écrit :
> Hi Linus
> 
> I got some freezes on two different machines, using latest kernel.
> 
> while :; do hackbench 10 thread 4000; done
> 
> Not sure I'll have time today to find the problem.
> 
> It might be related to "perf top" also being run at least once.
> 

Hmm, I can trigger the bug without ever using "perf".



