Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab2ASJZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 04:25:41 -0500
Received: from mail.us.es ([193.147.175.20]:51098 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756420Ab2ASJZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 04:25:36 -0500
Date: Thu, 19 Jan 2012 10:25:33 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Richard Weinberger <rw@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: Netfilter: New target: RLOG
Message-ID: <20120119092533.GA32602@1984>
References: <1326926610-17830-1-git-send-email-rw@linutronix.de>
 <20120119091248.GA32391@1984>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119091248.GA32391@1984>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 10:12:48AM +0100, Pablo Neira Ayuso wrote:
> I still think this can be useful.
> 
> But, why don't you add this to the LOG target as an extension instead
> of yet another target?

By "extension", I meant to say "revision".

If you're not familiar with the iptables revision mechanism, for
instance, have a look at net/netfilter/xt_NFQUEUE.c

Look for the "revision" pattern in that code. Basicaly, it allows you
to enhance existing matches/targets without breaking backward
compatibility.
