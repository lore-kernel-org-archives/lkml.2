Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab0FOGo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 02:44:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60109 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab0FOGo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 02:44:27 -0400
Date: Tue, 15 Jun 2010 08:44:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nils Carlson <nils.carlson@ludd.ltu.se>, Ingo Molnar <mingo@elte.hu>,
       Borislav Petkov <bp@amd64.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       "Young, Brent" <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100615064419.GA6727@basil.fritz.box>
References: <m1k4r0c0y7.fsf@fess.ebiederm.org> <20100518222832.GJ22675@basil.fritz.box> <m1wrv0zo9q.fsf@fess.ebiederm.org> <20100519064619.GA30320@aftab> <20100519070919.GA9618@elte.hu> <50689ECC-A371-4923-BEBE-1A5A7E5B9D3B@ludd.ltu.se> <20100614114906.GG17092@basil.fritz.box> <m14oh59y58.fsf@fess.ebiederm.org> <20100614203611.GE369@basil.fritz.box> <AANLkTil_mDFOsDUjvnp_NFZvkj0Ij-qww6BqewJ4lpHP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTil_mDFOsDUjvnp_NFZvkj0Ij-qww6BqewJ4lpHP@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There was a case mentioned at the collaboration summit
> meeting where a BIOS bug mis-reported whether ECC was
> enabled - claiming it was on, when in fact it was off.

Yes I heard about that, but since it's not a single bit setting
there are lots of different ways it could be broken in theory.

To check it you really need to have a tool that knows about
all the registers and checks them all.

It's a bit like checking if someone speaks a foreign language
by asking them a single question with a one letter answer.

> of the chipset specific code against each other. An EDAC
> driver that tells you that ECC is enabled might be lying too,
> if it is looking at the wrong bit or the wrong register.

Yep.

It's asking a question with a one word answer where you don't
know the correct answer.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
