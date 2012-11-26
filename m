Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab2KZIPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 03:15:18 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53556 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab2KZIPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 03:15:16 -0500
Date: Mon, 26 Nov 2012 00:15:12 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "founder.fang" <founder.fang@gmail.com>
Cc: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: hidraw: fix nonblock read return EAGAIN after
 device removed
Message-ID: <20121126081512.GD21091@core.coreip.homeip.net>
References: <CAHLfQU=Hrufny=652k2mM7OcjxnRMH-kgj510FZrrKtiKNxdgw@mail.gmail.com>
 <CAHLfQUnhEQBC+yzB3jFnJbB7jMvuVjr1M62kzxWzMN2v0i=VzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHLfQUnhEQBC+yzB3jFnJbB7jMvuVjr1M62kzxWzMN2v0i=VzA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Founder,

On Mon, Nov 26, 2012 at 10:30:37AM +0800, founder.fang wrote:
> Hi Linux-Input, Jiri, Dmitry,
> this patch is related to nonblock read on hidraw device.
> when nonblock read the condition check (file->f_flags & O_NONBLOCK)
> always be true,
> signal_pending and device exist checking never get a chance to run, so
> the user mode code always
> get EAGAIN even if device removed. move nonblock mode checking to the
> last can fix this problem.
> 
> Signed-off-by: Founder Fang <founder.fang@gmail.com>
> 

Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Makes sense to me. However it looks like your mailer line-wrapped the
patch, please resend so Jiri can apply it.

Thanks.

-- 
Dmitry
