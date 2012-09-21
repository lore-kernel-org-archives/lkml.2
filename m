Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab2IUPpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:45:00 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51548 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab2IUPo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:44:58 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: raven@themaw.net
Cc: autofs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, sukadev@linux.vnet.ibm.com,
        serge.hallyn@canonical.com, ebiederm@xmission.com
Subject: Re: [PATCH 0/2] struct pid-ify autofs4
References: <1348068576-21363-1-git-send-email-miklos@szeredi.hu>
Date: Fri, 21 Sep 2012 17:44:48 +0200
In-Reply-To: <1348068576-21363-1-git-send-email-miklos@szeredi.hu> (Miklos
	Szeredi's message of "Wed, 19 Sep 2012 17:29:34 +0200")
Message-ID: <87haqrwfbj.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> These two patches change autofs4 to store struct pid pointers instead of pid_t
> values.
>
> Fixed various issues with the previous post.  Not tested, handle with
> care!

Customer gave positive test results.

Thanks,
Miklos

>
> Thanks,
> Miklos
> ---
>
>
> Serge Hallyn (1):
>       autofs4: store struct pids in autofs_waitqs
>
> Sukadev Bhattiprolu (1):
>       Replace pid_t in autofs4 with struct pid reference.
>
> ---
>  fs/autofs4/autofs_i.h  |    8 ++++----
>  fs/autofs4/dev-ioctl.c |    3 ++-
>  fs/autofs4/inode.c     |   22 +++++++++++++++-------
>  fs/autofs4/waitq.c     |   19 +++++++++++++------
>  4 files changed, 34 insertions(+), 18 deletions(-)
