Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab0DOQVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 12:21:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab0DOQVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 12:21:37 -0400
Date: Thu, 15 Apr 2010 18:21:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dhaval Giani <dhaval.giani@gmail.com>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: WARNING: at kernel/lockdep.c:2696
 lockdep_init_map+0xd2/0x108()
In-Reply-To: <20100415152429.GE2471@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.1004151820220.28179@twin.jikos.cz>
References: <1271271162.9281.1.camel@localhost> <20100415152429.GE2471@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Apr 2010, Paul E. McKenney wrote:

> > I seem to be hitting this on bootup on a recent-ish git kernel (post
> > -rc4).
> 
> Is this addressed by ebd09ec93c90c8ec571d7e166832fb1fc705bf5e?

That's for a different issue (attribute_container_add_attrs() vs. 
atk_create_files()).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

