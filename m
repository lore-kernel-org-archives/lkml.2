Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab0HZLpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 07:45:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40757 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab0HZLpt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 07:45:49 -0400
Subject: Re: [PATCH] lglock: make lg_lock_global() actually lock globally
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100826113858.GA6856@amd>
References: <20100825132815.108d8217@bike.lwn.net>
	 <AANLkTimbiEMM+uyYtU41qdCuK7uRavtPYdQyx4d_g3xw@mail.gmail.com>
	 <4C762BF9.5010305@kernel.org> <20100826094613.GA6411@amd>
	 <4C7638B7.9060306@kernel.org> <1282817329.1975.486.camel@laptop>
	 <20100826113858.GA6856@amd>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 Aug 2010 13:45:39 +0200
Message-ID: <1282823139.1975.689.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 21:38 +1000, Nick Piggin wrote:
> I think for CPU plug, stop_machine is reasonable (especially
> considering it is required in unload, which means any frequent
> amount of cpu plug activity already will require stop_machine to
> run anyway). 

How is it required? 

Its currently implemented as such, and its sure a lot easier to do that
way, but I could imagine that unplugging a CPU could be done without it.


