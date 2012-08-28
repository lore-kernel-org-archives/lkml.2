Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2H1N5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 09:57:13 -0400
Received: from ozlabs.org ([203.10.76.45]:40131 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab2H1N5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 09:57:12 -0400
From: Rusty Russell <rusty@ozlabs.org>
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Remove CONFIG_EXPERIMENTAL
In-Reply-To: <20120827215356.GA27961@www.outflux.net>
References: <20120827215356.GA27961@www.outflux.net>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 28 Aug 2012 13:53:03 +0930
Message-ID: <878vczwspk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> This config item has not carried much meaning for a while now and is
> almost always enabled by default. Remove it and adjust various config
> logic and documentation.

Acked-by: Rusty Russell <rusty@rustcorp.com.au> (lguest part)

Cheers,
Rusty.
