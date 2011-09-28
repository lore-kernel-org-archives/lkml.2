Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab1I1QAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 12:00:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033Ab1I1QAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 12:00:31 -0400
Date: Wed, 28 Sep 2011 17:56:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Wilson <wilsons@start.ca>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Q: x86: add context tag to mark mm when running a task in
	32-bit compatibility mode
Message-ID: <20110928155655.GB10550@redhat.com>
References: <20110927170448.GA15977@redhat.com> <20110928020724.GA4524@wicker.gateway.2wire.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110928020724.GA4524@wicker.gateway.2wire.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27, Stephen Wilson wrote:
>
> On Tue, Sep 27, 2011 at 07:04:48PM +0200, Oleg Nesterov wrote:
> > I am asking because we probably want to backport this change and this
> > ia32_compat looks a bit annoying, why should we waste a word?
> >
> > Sure, this is very minor, but perhaps the trivial patch below makes
> > sense?
>
> Definitely makes sense (modulo Al's remarks).

OK, good.

I'll try to test (and double check) this patch, then I'll resend it
"officially".

Oleg.

