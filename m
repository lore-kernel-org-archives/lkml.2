Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab2ENLUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 07:20:13 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:32976 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab2ENLUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 07:20:11 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH 0/5] overlayfs v3.4-rc5 updates
References: <1335885475-11990-1-git-send-email-apw@canonical.com>
Date: Mon, 14 May 2012 13:20:40 +0200
In-Reply-To: <1335885475-11990-1-git-send-email-apw@canonical.com> (Andy
	Whitcroft's message of "Tue, 1 May 2012 16:17:50 +0100")
Message-ID: <87r4unqa9j.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft <apw@canonical.com> writes:

> I have been playing with getting overlayfs to work for v3.4, following
> this email are the patches I am using on top of the stock overlayfs.v12
> branch on the v3.4-rc5 base.  The first two are yet another revamp of the
> security permissions patch which I posted a few times (hopefully fixing
> your remaining comments).  The other three are porting issues for the
> v3.2->v3.4 base.
>
> These are also available as below:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/apw/overlayfs.git overlayfs.v12apw1
>
> Thanks to Sedat Dilek for all their testing feedback and Jordi Pojol for
> his test scripts.
>
> Please consider.

Thanks, applied.  Should appear shortly at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v13

Thanks,
Miklos
