Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247Ab2JTDWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 23:22:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab2JTDWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 23:22:15 -0400
Date: Fri, 19 Oct 2012 20:22:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] use clamp_t in UNAME26 fix
Message-Id: <20121019202204.76666c39.akpm@linux-foundation.org>
In-Reply-To: <20121020014553.GA6785@www.outflux.net>
References: <20121020014553.GA6785@www.outflux.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012 18:45:53 -0700 Kees Cook <keescook@chromium.org> wrote:

> 
> The min/max call needed to have explicit types on some architectures
> (e.g. mn10300). Use clamp_t instead to avoid the warning.
> 
> kernel/sys.c: In function 'override_release':
> kernel/sys.c:1287:10: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Needs a cc:stable in the changelog before committing, please.
