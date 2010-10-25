Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab0JYAHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 20:07:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492Ab0JYAHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 20:07:50 -0400
MIME-Version: 1.0
In-Reply-To: <1287957832.24074.19.camel@maxim-laptop>
References: <4CC49274.3030803@fusionio.com> <AANLkTik4qAzZPLO8HHBCM34_NLEEdPj04RyXPfeR-wSv@mail.gmail.com>
 <4CC49A4B.8010300@fusionio.com> <1287957832.24074.19.camel@maxim-laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 24 Oct 2010 17:07:00 -0700
Message-ID: <AANLkTi=VH03ZL023VT+KYUXKHhZ80TzwqhQeRf17oENG@mail.gmail.com>
Subject: Re: [GIT PULL] Revert of the IO stat fix
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 24, 2010 at 3:03 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
>
> Btw I had that bug reproduced 100% for all removeable devices I have.
> (xD, ms, usb).

Does Jens' suggested patch (the non-revert one) fix your oops? Or only
the revert?

IOW, I would want to know whether I could try just merging the fix
instead of backing out the patch that looks like a real improvement..

                    Linus
