Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab2C1Vdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:33:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932293Ab2C1Vdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:33:44 -0400
Date: Wed, 28 Mar 2012 23:26:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysrq: Use SEND_SIG_FORCED instead of force_sig()
Message-ID: <20120328212606.GA8771@redhat.com>
References: <20120324110024.GA14067@lizard> <20120326154303.86126785.akpm@linux-foundation.org> <20120328205254.GA6930@redhat.com> <20120328140835.38e1f03f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328140835.38e1f03f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28, Andrew Morton wrote:
>
> On Wed, 28 Mar 2012 22:52:54 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > No, this depends on 629d362b9950166c6fac2aa8425db34d824bb043
> > "signal: give SEND_SIG_FORCED more power to beat SIGNAL_UNKILLABLE".
>
> oop, I meant "this patch looks like 3.4 material"?

Ah, yes, in this case I agree.

Oleg.

