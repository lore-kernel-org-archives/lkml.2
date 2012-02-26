Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab2BZQCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 11:02:31 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54467 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab2BZQCa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 11:02:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jwboyer@gmail.com designates 10.216.131.23 as permitted sender) smtp.mail=jwboyer@gmail.com; dkim=pass header.i=jwboyer@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120226151015.GA14324@redhat.com>
References: <20120226151015.GA14324@redhat.com>
Date: Sun, 26 Feb 2012 11:02:28 -0500
Message-ID: <CA+5PVA4-yj26KVyoTBkP3v3=0ZJ6HLh0aWLaHaXgqn_FMqeaLQ@mail.gmail.com>
Subject: Re: [PATCH] autofs: fix 3.3-rc5 compilation breakage on x86-32
From: Josh Boyer <jwboyer@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Ian Kent <raven@themaw.net>, autofs@linux.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 26, 2012 at 10:10 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Recent commit a32744d4abae24572eff7269bc17895c41bd0085 broke autofs
> compilation on x86-32:
>
> fs/autofs4/inode.c: In function ‘autofs4_fill_super’:
> fs/autofs4/inode.c:228: error: implicit declaration of function ‘is_compat_task’
>
> This patch fix that by adding #if checks.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Andreas Schwab submitted an identical patch.  Linus came up with something
else:

https://lkml.org/lkml/2012/2/25/84

josh
