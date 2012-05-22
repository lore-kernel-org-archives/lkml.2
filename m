Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab2EVBvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:51:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:38772 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab2EVBvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:51:22 -0400
Message-ID: <1337651473.2779.140.camel@pasglop>
Subject: powerpc -next rebase WARNING
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@kernel.crashing.org>, Josh Boyer <jwboyer@gmail.com>
Date: Tue, 22 May 2012 11:51:13 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks, bad news ... my fault.

I accidentally forgot a --signoff on a git am command last week, meaning
that a pair of patches are in -next and not signed off by me.

For various (legal) reasons that cannot go into Linus tree as-is, so I
have to rebase the tree to fix it.

Sorry about that ...

Cheers,
Ben.


