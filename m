Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab2JWCA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 22:00:57 -0400
Received: from ozlabs.org ([203.10.76.45]:57270 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472Ab2JWCA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 22:00:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] arch/tile: avoid build warnings from duplicate ELF_R_xxx #defines
In-Reply-To: <201210192039.q9JKdUE5003952@farm-0010.internal.tilera.com>
References: <201210192039.q9JKdUE5003952@farm-0010.internal.tilera.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 22 Oct 2012 13:46:27 +1030
Message-ID: <87vce3i4c4.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Metcalf <cmetcalf@tilera.com> writes:

> These are now provided in <asm-generic/module.h>, so clean up warning
> by not re-defining them in module.c.
>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

This change was in linux-next for quite a while, BTW, so there would
have been over a month of warnings...

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.
