Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2A3IEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 03:04:24 -0500
Received: from ozlabs.org ([203.10.76.45]:40082 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab2A3IEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 03:04:23 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Subject: Re: [PATCH] module: avoid call vmalloc if init size is zero
In-Reply-To: <4F26468C.4000302@linaro.org>
References: <1327648756-22255-1-git-send-email-dmitry.antipov@linaro.org> <8762fxcrvx.fsf@rustcorp.com.au> <4F26468C.4000302@linaro.org>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 30 Jan 2012 18:24:18 +1030
Message-ID: <878vkpmxqt.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012 11:28:12 +0400, Dmitry Antipov <dmitry.antipov@linaro.org> wrote:
> On 01/27/2012 03:21 PM, Rusty Russell wrote:
> 
> > Please fix __vmalloc_node_range() instead to return ZERO_SIZE_PTR.
> > And of course, vfree() to use ZERO_OR_NULL_PTR().
> 
> For the convenience and uniformity, should {alloc,free}_percpu() be
> also modified in that way?

Yep!

Thanks,
Rusty.
