Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab2JQFnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 01:43:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53004 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab2JQFni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 01:43:38 -0400
Date: Wed, 17 Oct 2012 06:43:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: new execve/kernel_thread design
Message-ID: <20121017054337.GX2616@ZenIV.linux.org.uk>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
 <CAMo8BfLdm1OvJTU2y-YQtoPffYsP=UzRco_q2GHWTo-bYQO4ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMo8BfLdm1OvJTU2y-YQtoPffYsP=UzRco_q2GHWTo-bYQO4ug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 09:32:34AM +0400, Max Filippov wrote:
> On Wed, Oct 17, 2012 at 2:35 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > [apologies for enormous Cc; I've talked to some of you in private mail
> > and after being politely asked to explain WTF was all that thing for
> > and how was it supposed to work, well...]
> 
> [...]
> 
> > Not even a tentative patchset: hexagon, openrisc, tile, xtensa.
> 
> I'm doing xtensa part.

Thanks; I hope this variant is going to be less painful than messing with
ret_from_kernel_execve()...

> BTW, what linus-arch ML might be for?

A typo, noticed only when I got a bounce ;-)
My apologies...
