Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523Ab0DWSBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 14:01:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757307Ab0DWSBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 14:01:35 -0400
Date: Fri, 23 Apr 2010 11:00:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       Paulius Zaleckas <paulius.zaleckas@gmail.com>, dwmw2@infradead.org,
       jamie@shareable.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, u.kleine-koenig@pengutronix.de,
       simon.kagstrom@netinsight.net, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] MTD: Fix Orion NAND driver compilation with ARM OABI
Message-Id: <20100423110037.f8790476.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004231308300.7232@xanadu.home>
References: <20100325152505.17612.40158.stgit@pauliusz>
	<alpine.LFD.2.00.1003251225500.694@xanadu.home>
	<4BB33988.9070608@gmail.com>
	<1272023778.6917.6.camel@localhost>
	<alpine.LFD.2.00.1004230853230.7232@xanadu.home>
	<1272035596.11751.1437.camel@localhost.localdomain>
	<alpine.LFD.2.00.1004231308300.7232@xanadu.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 13:50:10 -0400 (EDT)
Nicolas Pitre <nico@fluxnic.net> wrote:

> > Fine with me, but not up to me. But I guess Andrew could merge it.
> 
> The patch is providing a fix to my own code, and I acked it already. The 
> root of the problem is a defficiency in gcc, and dwmw2 asked that a PR 
> be filled for that and a reference to it added to the patch.  This has 
> been done.

Well, I merged it and can send it upstream.  But Jamie's observations
give me pause?

