Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab2B0X0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 18:26:38 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:47095 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab2B0X0h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 18:26:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.107.68 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330370242.25686.196.camel@gandalf.stny.rr.com>
References: <1330370242.25686.196.camel@gandalf.stny.rr.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Feb 2012 15:26:16 -0800
X-Google-Sender-Auth: BrD4oCXEvOlY5B_0iFEtCR8mI9I
Message-ID: <CA+55aFw5hhQQU-X_n=Q98Xt_UVKUgeVJ53BhwDgFvXSSt_0Bjw@mail.gmail.com>
Subject: Re: [PATCH][GIT PULL][v3.3] ktest: Fix make_min_config test when
 build fails
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 11:17 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Please pull the latest for-linus tree, which can be found at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
> ktest-fix-make-min-failed-build

I'm getting "Already up-to-date" with that tag. It points to your old
commit be405f95f0a0 ("ktest: Add INGORE_ERRORS to ignore warnings in
boot up") and normally I'd ask whether you perhaps forgot to push, but
considering the fairly unique naming of that tag, you clearly *did*
push.

Congratulations, you seem to have found a whole new and unique way of
screwing up ;)

               Linus "my mom called me 'special' too" Torvalds
