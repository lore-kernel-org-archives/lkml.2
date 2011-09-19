Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab1ISC53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 22:57:29 -0400
Received: from ozlabs.org ([203.10.76.45]:38799 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805Ab1ISC52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 22:57:28 -0400
Subject: Re: [GIT] Networking
From: Jeremy Kerr <jk@ozlabs.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, david.ward@ll.mit.edu,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CA+55aFyENEpGJmTq55=n0_gDiF6RQmdKw-ts4AdQAFQJ1TkF-Q@mail.gmail.com>
References: <20110918.022125.1554085675403900813.davem@davemloft.net>
	 <CA+55aFxc1tMCXKBV33PVD5BybTLBpfJAEcObvoQwbwqbKOsp7g@mail.gmail.com>
	 <4E76864D.4080907@ll.mit.edu>
	 <20110918.210344.570661374586887894.davem@davemloft.net>
	 <CA+55aFyENEpGJmTq55=n0_gDiF6RQmdKw-ts4AdQAFQJ1TkF-Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 10:57:23 +0800
Message-ID: <1316401043.2768.52.camel@pororo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

> Hmm. I *think* the right person for patchwork issues is Jeremy Kerr,
> but I migth be wrong..

Yes, that's correct.

> Jeremy, the fact that apparently patchworks loses proper names is a
> killer feature - but very much in the wrong meaning of "killer". Any
> way to make sure that doesn't happen?

Yeah, probably not the killer feature we're after.

I've found the problem, and committed a fix & testcase:

 http://git.ozlabs.org/?p=patchwork;a=commitdiff;h=4bc2c34d

That fix has been applied to the patchwork.ozlabs.org instance, and I've
manually updated the incorrect (ie, username-only) entries in the
patchwork database.

Cheers,


Jeremy

