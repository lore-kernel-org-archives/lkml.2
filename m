Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966157Ab2JZTV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 15:21:26 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40941 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966098Ab2JZTVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 15:21:24 -0400
MIME-Version: 1.0
In-Reply-To: <20121026185021.GA1960@www.outflux.net>
References: <20121026185021.GA1960@www.outflux.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Oct 2012 12:21:02 -0700
X-Google-Sender-Auth: 4da0lCvvhtUzSC9srzNWeV7Sm6s
Message-ID: <CA+55aFxSO9oGtNEBOAVXj+OQn0tye7rNBu8C5tsggsYdZarNrw@mail.gmail.com>
Subject: Re: [PATCH] VFS: add config options to enable link restrictions
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 11:50 AM, Kees Cook <keescook@chromium.org> wrote:
> There are situations where devices running without initrds may need
> very early protection from link vulnerabilities

I really don't see what this argument is all about.

If you don't have initrd, you still have early bootup scripts etc.

If your early bootup has security problems, you have security
problems. It has nothing to do with initrd, or with restricted links,
or anything else.

I also refuse to add these kinds of micro-management config options
and ask any kind of normal person these kinds of "do you want this
random crazy feature". A config option would need to be way more sane,
not this kind of micro-management.

                 Linus
