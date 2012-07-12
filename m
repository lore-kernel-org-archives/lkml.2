Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162478Ab2GLW6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:58:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162107Ab2GLW6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:58:09 -0400
Date: Thu, 12 Jul 2012 15:58:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Evgeniy Dushistov <dushistov@mail.ru>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] fs/ufs: stop using write_supers and s_dirt
Message-Id: <20120712155808.807ec3f5.akpm@linux-foundation.org>
In-Reply-To: <1342099688-14894-1-git-send-email-dedekind1@gmail.com>
References: <1342099688-14894-1-git-send-email-dedekind1@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012 16:28:05 +0300
Artem Bityutskiy <dedekind1@gmail.com> wrote:

> Note, checkpatch.pl complains about these patches, but the complaints are about
> the code which is already in UFS, not my code. We really need to fix
> checkpatch.pl to be smarter.

Just fix them up as you go - the code is already a mixture of "right"
and "wrong" (a consequence of a lot of it being "wrong") - we might as
well tip it further in the "right" direction.
