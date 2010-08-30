Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab0H3OQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 10:16:05 -0400
Received: from ist.d-labs.de ([213.239.218.44]:53146 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab0H3OQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 10:16:03 -0400
Date: Mon, 30 Aug 2010 16:16:01 +0200
From: Florian Mickler <florian@mickler.org>
To: auto595907@hushmail.com
Newsgroups: gmane.linux.kernel
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org
Subject: Re: [Bug #16423] netfilter/iptables stopped logging 2.6.35-rc
Message-ID: <20100830161601.46eb86a2@schatten.dmk.lab>
In-Reply-To: <20100830050510.0CD771200AA@smtp.hushmail.com>
References: <20100830050510.0CD771200AA@smtp.hushmail.com>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010 08:05:09 +0300
auto595907@hushmail.com wrote:

> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=16423
> Subject        : netfilter/iptables stopped logging 2.6.35-rc
> Submitter    : auto401300@hushmail.com
> Date        : 2010-07-17 10:20 (44 days old)
> Message-ID    : <20100717072036.1BBE52804B@smtp.hushmail.com>
> References    :
> http://lkml.indiana.edu/hypermail/linux/kernel/1007.2/00440.html
> 
> 
> this patch fixes the bug above:
> (http://marc.info/?l=netfilter-devel&m=128116762801769&w=2)
> 
> fixed in 2.6.36-rc3
> 

Which turns up as mainline commit:

commit cca77b7c81876d819a5806f408b3c29b5b61a815
Author: Florian Westphal <fw@strlen.de>
Date:   Mon Aug 23 14:41:22 2010 -0700

    netfilter: fix CONFIG_COMPAT support

> 
> thanks 
> 

I've closed the bugreport and pinged the maintainers for stable
backport.

Cheers,
Flo
