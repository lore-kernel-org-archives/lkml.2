Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab2JXPsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:48:10 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45704 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751161Ab2JXPsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:48:06 -0400
X-Sasl-enc: ogiptH5VsrMmocdnrPb2c7aOwN/XaDSfa99pReFlZiy/ 1351093685
Date: Wed, 24 Oct 2012 08:48:04 -0700
From: Greg KH <greg@kroah.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] use clamp_t in UNAME26 fix
Message-ID: <20121024154804.GB30669@kroah.com>
References: <20121020014553.GA6785@www.outflux.net>
 <20121019202204.76666c39.akpm@linux-foundation.org>
 <CAGXu5j+80oat9gkq6-9vtMUo33BC8D=A1rPQF5yE89M-Kq=G7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+80oat9gkq6-9vtMUo33BC8D=A1rPQF5yE89M-Kq=G7g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 09:30:24PM -0700, Kees Cook wrote:
> Argh, whoops. Greg, can you please include
> 31fd84b95eb211d5db460a1dda85e004800a7b52 in stable?

Now applied, thanks.

greg k-h
