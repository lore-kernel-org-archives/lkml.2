Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab1J0Mhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 08:37:50 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:52417 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754521Ab1J0Mht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 08:37:49 -0400
X-Sasl-enc: A4xVCpzeT0NbWZ3dIN/8Z0JN68K1EaQNUa72VQsqtZBe 1319719068
Date: Thu, 27 Oct 2011 14:37:42 +0200
From: Greg KH <greg@kroah.com>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] TTY: pty, fix pty counting in
 "/proc/sys/kernel/pty/nr"
Message-ID: <20111027123742.GB7910@kroah.com>
References: <4EA928F3.7010204@ilyx.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA928F3.7010204@ilyx.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 01:48:35PM +0400, Ilya Zykov wrote:
> Regression for commit: 24d406a6bf736f7aebdc8fa0f0ec86e0890c6d24
> Commit: 24d406a6b accepted in Linux 3.1.
> Disscussed on linux-kernel@vger.kernel.org "subject: [PATCH] TTY: pty, fix pty counting"
> and not accepted.
> Although, I think it's clear.

Ilya, is there some reason you are ignoring the tty maintainer and
sending these to Linus directly?  These patches need to be tested in
linux-next, so at the earliest, they can be merged into Linus's tree for
3.3, they are NOT 3.2 material, especially given that they are not even
accepted by the current tty developers.

So please work with us, and don't try to circumvent the existing
process, it is not the way we work here.

Especially as this specific patch was already rejected, for very good
reasons, why are you ignoring those reasons?

thanks,

greg k-h
