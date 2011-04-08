Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab1DHNci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 09:32:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:34388 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab1DHNch convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 09:32:37 -0400
Subject: Re: Q. lockdep_assert_held() and lockdep_off/on()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <9752.1302268789@jrobl>
References: <9752.1302268789@jrobl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 08 Apr 2011 15:32:30 +0200
Message-ID: <1302269550.9086.142.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-08 at 22:19 +0900, J. R. Okajima wrote:
> Hello Peter Zijlstra and Ingo Molnar,
> 
> May I ask you a question about the commit
> 	f607c66 2009-08-02 lockdep: Introduce lockdep_assert_held()
> 
> In short, should lockdep_assert_held() support ->lockdep_recursion?

Probably, however

> Its current definition is
> #define lockdep_assert_held(l) WARN_ON(debug_locks && !lockdep_is_held(l))
> 
> When someone somewhere calls lockdep_off() and executes some memory

you're not supposed to do that..


