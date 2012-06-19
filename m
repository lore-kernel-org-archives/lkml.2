Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab2FSMfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 08:35:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51319 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab2FSMfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 08:35:52 -0400
Subject: Re: [net-next:master 49/50]
 net/netfilter/nfnetlink_queue_ct.c:23:18: sparse: incompatible types in
 comparison expression (different address spaces)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Fengguang Wu <wfg@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120619115640.GA683@1984>
References: <20120619060050.GA14867@localhost> <20120619112823.GB445@1984>
	 <20120619114113.GA19526@localhost>  <20120619115640.GA683@1984>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jun 2012 14:35:47 +0200
Message-ID: <1340109347.4604.7.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-19 at 13:56 +0200, Pablo Neira Ayuso wrote:

> I don't hit those errors here with:
> 
> make C=2 net/netfilter/nfnetlink_queue_ct.o
> 
> using latest sparse from git tree.
> 
> I guess it's related to some missing __rcu tag, but I need to make
> sure. I don't want to play whack-a-mole game ;-).

Hint :

CONFIG_SPARSE_RCU_POINTER=y



