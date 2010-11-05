Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab0KEWDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 18:03:36 -0400
Received: from borg.medozas.de ([188.40.89.202]:44424 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab0KEWDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 18:03:35 -0400
Date: Fri, 5 Nov 2010 23:03:31 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jan Kara <jack@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <jens.axboe@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
        gregkh@suse.de
Subject: Re: Sync writeback still broken
In-Reply-To: <20101105213324.GA25520@quack.suse.cz>
Message-ID: <alpine.LNX.2.01.1011052302400.17206@obet.zrqbmnf.qr>
References: <20100212091609.GB1025@kernel.dk> <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain> <alpine.LSU.2.01.1002131356250.20838@obet.zrqbmnf.qr> <20100215144938.GD3434@quack.suse.cz> <alpine.LSU.2.01.1002151629380.27775@obet.zrqbmnf.qr>
 <alpine.LSU.2.01.1006271842220.1495@obet.zrqbmnf.qr> <alpine.LNX.2.01.1010250115360.16022@obet.zrqbmnf.qr> <20101031122437.GA6296@quack.suse.cz> <20101031224012.GB13207@quack.suse.cz> <20101105213324.GA25520@quack.suse.cz>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2010-11-05 22:33, Jan Kara wrote:
>  OK, so at Kernel Summit we agreed to fix the issue as I originally wanted
>by patches
>http://marc.info/?l=linux-fsdevel&m=128861735213143&w=2
>and
>http://marc.info/?l=linux-fsdevel&m=128861734813131&w=2
>
>  I needed one more patch to resolve the issue (attached) which I've just
>posted for review and possible inclusion.

If you have a branch that has all three and is easy to fetch, I'll
get on it right away.
