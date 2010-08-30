Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab0H3TKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 15:10:24 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:42550 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab0H3TKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 15:10:23 -0400
Date: Mon, 30 Aug 2010 21:10:21 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] init: use kern_sys_* wrappers instead of syscall
Message-ID: <20100830191021.GC12921@merkur.ravnborg.org>
References: <1283189270-7274-1-git-send-email-namhyung@gmail.com> <1283189270-7274-3-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283189270-7274-3-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 02:27:50AM +0900, Namhyung Kim wrote:
> replace direct syscall invocations to its wrapper functions defined
> in init/sys-wrapper.h

Please explain again that this fixes sparse warnings.
And list the sparse warnings that gets fixed - or at least some
abbrevated sample of tham.

Comment about inverse christmas tree apply to this patch in a few spots.

The patch does not apply to -linus.
In realise this is because it is made on top of another patch of yours
that is already in -mm.

But it would be better to say that this first patch should be replaced
by this second patch that does the same and more.

	Sam
