Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab0FMOyf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 10:54:35 -0400
Received: from lo.gmane.org ([80.91.229.12]:48438 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938Ab0FMOye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 10:54:34 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: Jindrich Makovicka <makovick@gmail.com>
Subject: Re: [REGRESSION]linux-2.6.35-rc3 in net/core/dev.c
Date: Sun, 13 Jun 2010 16:54:21 +0200
Message-ID: <20100613165421.7e8dda79@holly>
References: <201006131625.55481.mitov@issp.bas.bg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: rb5cl87.net.upc.cz
In-Reply-To: <201006131625.55481.mitov@issp.bas.bg>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jun 2010 16:25:54 +0300
Marin Mitov <mitov@issp.bas.bg> wrote:

> Hi all,
> 
> I am using ssh with port redirection to log on host_at_work:
> 
> ssh -L20110:mail:110 host_at_work
> 
> With linux-2.6.35-rc3, when I telnet to localhost I get:
> 
> telnet localhost 20110
> Trying 127.0.0.1...
> telnet: connect to address 127.0.0.1: Connection timed out
[...]
> 
> I have seen the posting on LKML:
> 
> http://lkml.org/lkml/2010/6/13/11
> 
> and decided to revert the patch mentioned their (see bellow).
> The revert solves the problem for me.

I can confirm this. Reverting of this patch fixes a regression with
Privoxy running on localhost, where most of the connections
(browser->proxy) stall and don't return anything.

-- 
Jindrich Makovicka


