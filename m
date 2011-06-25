Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab1FYKjc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 06:39:32 -0400
Received: from mail.southpole.se ([193.12.106.18]:56542 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1FYKjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 06:39:31 -0400
Subject: Re: [PATCH] modules: add default loader hook implementations
From: Jonas Bonn <jonas@southpole.se>
To: Ingo Molnar <mingo@elte.hu>
Cc: rusty@rustcorp.com.au, arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, monstr@monstr.eu, cmetcalf@tilera.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110625100449.GA19097@elte.hu>
References: <1308987512-6583-1-git-send-email-jonas@southpole.se>
	 <20110625100449.GA19097@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Organization: South Pole Consulting AB
Date: Sat, 25 Jun 2011 12:39:27 +0200
Message-ID: <1308998367.6699.30.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2011-06-25 at 12:04 +0200, Ingo Molnar wrote:
> Also, and more importantly, don't we generally do such things via 
> __weak aliases, because the result looks cleaner and needs no changes 
> for architectures beyond the removal of the generic functions? We 
> have excluded broken toolchains that miscompile/mislink __weak IIRC 
> so __weak ought to work.

When we discussed this briefly yesterday, both Rusty and Arnd showed a
preference for not using __weak aliases... I'll leave it to them to
comment further.

The alternative patch that just provides __weak implementations for
these hooks is much less invasive than the patch I sent, effectively
touching only kernel/module.c

Let me know which is preferable.

/Jonas


