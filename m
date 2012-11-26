Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2KZNS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:18:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab2KZNSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:18:55 -0500
Date: Mon, 26 Nov 2012 14:18:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "founder.fang" <founder.fang@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: hidraw: fix nonblock read return EAGAIN after device
 removed
In-Reply-To: <20121126081512.GD21091@core.coreip.homeip.net>
Message-ID: <alpine.LNX.2.00.1211261417470.12570@pobox.suse.cz>
References: <CAHLfQU=Hrufny=652k2mM7OcjxnRMH-kgj510FZrrKtiKNxdgw@mail.gmail.com> <CAHLfQUnhEQBC+yzB3jFnJbB7jMvuVjr1M62kzxWzMN2v0i=VzA@mail.gmail.com> <20121126081512.GD21091@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2012, Dmitry Torokhov wrote:

> > Hi Linux-Input, Jiri, Dmitry,
> > this patch is related to nonblock read on hidraw device.
> > when nonblock read the condition check (file->f_flags & O_NONBLOCK)
> > always be true,
> > signal_pending and device exist checking never get a chance to run, so
> > the user mode code always
> > get EAGAIN even if device removed. move nonblock mode checking to the
> > last can fix this problem.
> > 
> > Signed-off-by: Founder Fang <founder.fang@gmail.com>
> > 
> 
> Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> Makes sense to me. However it looks like your mailer line-wrapped the
> patch, please resend so Jiri can apply it.

For some reason, the patch has been sent to me twice, once it has been 
fine and the second time it has been line wrapped.

I have now applied the non-broken version. Thanks,

-- 
Jiri Kosina
SUSE Labs
