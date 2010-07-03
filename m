Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab0GCDFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 23:05:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754414Ab0GCDFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 23:05:34 -0400
MIME-Version: 1.0
In-Reply-To: <201007031235.29637.rusty@rustcorp.com.au>
References: <201007031235.29637.rusty@rustcorp.com.au>
Date: Fri, 2 Jul 2010 20:05:23 -0700
Message-ID: <AANLkTikYIlpvz1oRvaT_SiK4GRhRuUto_MZqluSAVuoH@mail.gmail.com>
Subject: Re: [PATCH] module: initialize module dynamic debug later
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 2, 2010 at 7:35 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> We should initialize the module dynamic debug datastructures
> only after determining that the module is not loaded yet. This
> fixes a bug that introduced in 2.6.35-rc2, where when a trying
> to load a module twice, we also load it's dynamic printing data
> twice which causes all sorts of nasty issues. Also handle
> the dynamic debug cleanup later on failure.
>
> Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (removed a #ifdef)

Is this missing a

   From: Yehuda Sadeh <yehuda@hq.newdream.net>

author attribution by any chance? The sign-offs imply so.

                   Linus
