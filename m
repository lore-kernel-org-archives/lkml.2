Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525Ab1F1Qvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:51:50 -0400
Received: from mail.southpole.se ([193.12.106.18]:54237 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758718Ab1F1QvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:51:04 -0400
Subject: Re: [PATCH] modules: add default loader hook implementations
From: Jonas Bonn <jonas@southpole.se>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        monstr@monstr.eu, cmetcalf@tilera.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <201106281245.19457.arnd@arndb.de>
References: <1308987512-6583-1-git-send-email-jonas@southpole.se>
	 <201106271305.44746.arnd@arndb.de> <87mxh2lpey.fsf@rustcorp.com.au>
	 <201106281245.19457.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Organization: South Pole Consulting AB
Date: Tue, 28 Jun 2011 18:50:59 +0200
Message-ID: <1309279859.19420.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2011-06-28 at 12:45 +0200, Arnd Bergmann wrote:
> On Tuesday 28 June 2011, Rusty Russell wrote:
> > To avoid more bikeshedding, smallest patch wins.  That's __weak, right?
> 
> Sounds fine to me. Jonas, can you send that patch?
> 

Yes, for sure... just as soon as I get a spare moment, which will be in
a day or two.

/Jonas

