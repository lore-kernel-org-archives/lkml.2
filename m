Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab1CBMny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 07:43:54 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50496 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757046Ab1CBMnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 07:43:52 -0500
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, apw@canonical.com
In-reply-to: <AANLkTimVPaTm45q8ZfKpQGjiyTwyOuHJVMuOOHzgY75P@mail.gmail.com>
	(message from richard -rw- weinberger on Tue, 1 Mar 2011 16:49:07
	+0100)
Subject: Re: [PATCH 2/6 v6] vfs: export do_splice_direct() to modules
References: <20110301123645.189703316@szeredi.hu>
	<20110301123701.955702964@szeredi.hu> <AANLkTimVPaTm45q8ZfKpQGjiyTwyOuHJVMuOOHzgY75P@mail.gmail.com>
Message-Id: <E1PulP9-0000lS-G0@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 02 Mar 2011 13:43:47 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011, richard -rw- weinberger wrote:
> > +EXPORT_SYMBOL(do_splice_direct);
> 
> I have a question on your patch, why are you using EXPORT_SYMBOL()
> instead of EXPORT_SYMBOL_GPL()?
> Are you using EXPORT_SYMBOL() because all symbols in fs/splice.c
> are exported via EXPORT_SYMBOL()?
> 
> To be more precise, are there any rules to decide when _GPL() should be used?
> IMHO we should always use _GPL() for new symbols.

I don't think there are any written rules.

I'd use EXPORT_SYMBOL() when the provided API is reasonably "clean"
(i.e. it hides the implementation well enough).

Thanks,
Miklos
