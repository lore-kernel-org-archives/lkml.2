Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab0HZKIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 06:08:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:47605 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0HZKIX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 06:08:23 -0400
Subject: Re: [PATCH] lglock: make lg_lock_global() actually lock globally
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100826094613.GA6411@amd>
References: <20100825132815.108d8217@bike.lwn.net>
	 <AANLkTimbiEMM+uyYtU41qdCuK7uRavtPYdQyx4d_g3xw@mail.gmail.com>
	 <4C762BF9.5010305@kernel.org>  <20100826094613.GA6411@amd>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 Aug 2010 12:08:08 +0200
Message-ID: <1282817288.1975.485.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 19:46 +1000, Nick Piggin wrote:
> Why is that? Don't tell me realtime people want some latency "guarantee"
> while onlining CPUs? :) 

I think its only done because we can, don't use kstopmachine if you
don't have to etc..

We tell people who do RT not to hotplug, not load modules etc..
