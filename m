Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab0H0H74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 03:59:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37470 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab0H0H7v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 03:59:51 -0400
Subject: Re: [PATCH] lglock: make lg_lock_global() actually lock globally
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1282895856.1975.1711.camel@laptop>
References: <20100825132815.108d8217@bike.lwn.net>
	 <AANLkTimbiEMM+uyYtU41qdCuK7uRavtPYdQyx4d_g3xw@mail.gmail.com>
	 <4C762BF9.5010305@kernel.org> <20100826094613.GA6411@amd>
	 <4C7638B7.9060306@kernel.org> <1282817329.1975.486.camel@laptop>
	 <20100826113858.GA6856@amd> <1282823139.1975.689.camel@laptop>
	 <20100827055105.GA3857@amd>  <1282895856.1975.1711.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 27 Aug 2010 09:59:45 +0200
Message-ID: <1282895985.1975.1717.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 09:57 +0200, Peter Zijlstra wrote:
> 
> 
> There's a large three lettered company that's promoting cpu hotplug use
> for power management, they hotplug at an astonishing rate.
> 
> I've been saying hotplug isn't for that, and its a terrible slow path
> and disrupts your whole machine etc.. they don't seem to care much. 

Oh, and the virt community seems to want (or is) doing the same silly
thing.
