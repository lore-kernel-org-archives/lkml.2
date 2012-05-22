Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab2EVElH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 00:41:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:33068 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab2EVElG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 00:41:06 -0400
Message-ID: <1337661655.2779.167.camel@pasglop>
Subject: Re: powerpc -next rebase WARNING
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@kernel.crashing.org>, Josh Boyer <jwboyer@gmail.com>
Date: Tue, 22 May 2012 14:40:55 +1000
In-Reply-To: <1337651473.2779.140.camel@pasglop>
References: <1337651473.2779.140.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 11:51 +1000, Benjamin Herrenschmidt wrote:
> Folks, bad news ... my fault.
> 
> I accidentally forgot a --signoff on a git am command last week, meaning
> that a pair of patches are in -next and not signed off by me.
> 
> For various (legal) reasons that cannot go into Linus tree as-is, so I
> have to rebase the tree to fix it.
> 
> Sorry about that ...

Note that the rebase only affects the top 3 commits, so if your
tree is based on something older you're fine (Kumar, you seem to
be ok, I haven't checked Josh).

Cheers,
Ben.


