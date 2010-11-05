Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab0KEVfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 17:35:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab0KEVe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 17:34:58 -0400
Date: Fri, 5 Nov 2010 22:34:56 +0100
From: Jan Kara <jack@suse.cz>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <jens.axboe@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
        gregkh@suse.de
Subject: Re: Sync writeback still broken
Message-ID: <20101105213456.GB25520@quack.suse.cz>
References: <20100212091609.GB1025@kernel.dk>
 <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain>
 <alpine.LSU.2.01.1002131356250.20838@obet.zrqbmnf.qr>
 <20100215144938.GD3434@quack.suse.cz>
 <alpine.LSU.2.01.1002151629380.27775@obet.zrqbmnf.qr>
 <alpine.LSU.2.01.1006271842220.1495@obet.zrqbmnf.qr>
 <alpine.LNX.2.01.1010250115360.16022@obet.zrqbmnf.qr>
 <20101031122437.GA6296@quack.suse.cz>
 <20101031224012.GB13207@quack.suse.cz>
 <20101105213324.GA25520@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101105213324.GA25520@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 05-11-10 22:33:24, Jan Kara wrote:
>   I needed one more patch to resolve the issue (attached) which I've just
> posted for review and possible inclusion. I had a similar one long time ago
> but now I'm better able to explain why it works because of tracepoints.
> Yay! ;). With those three patches I'm not able to trigger livelocks (but
> sync takes still 15 minutes because the througput to disk is about 4MB/s -
> no big surprise given the random nature of the load)
  PS: And big thanks to you for providing the test case and your
persistence ;)
 
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
