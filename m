Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab1EITPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 15:15:07 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62998 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab1EITPF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 15:15:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=uaE7raLxCQxhLdP3T7GlAoGIEfCOD0fcyYtxm33L4bpShajhT602ufCl7Vk/6I9ozg
         eqO1SU0rtHIIHTRk5z26aZWzgquCDZt1Y/Jp5TdVXPqplJGeN3yq6GpO7HstA1rmwyjf
         20H9Rzm7aWBFAW4F/QrqDczU6UGazKYzIVrhA=
MIME-Version: 1.0
In-Reply-To: <1303142440-26328-1-git-send-email-miklos@szeredi.hu>
References: <1303142440-26328-1-git-send-email-miklos@szeredi.hu>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Mon, 9 May 2011 21:14:44 +0200
X-Google-Sender-Auth: k4himAg3HshZ1xRTf4zvX-OBFfY
Message-ID: <BANLkTinNk=8F5qf13DJsKObJGLtQiRyA7A@mail.gmail.com>
Subject: Re: [PATCH 0/6] overlay filesystem
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

On 18 April 2011 18:00, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Here's an updated version of the overlay filesystem.
>
> Git tree is here:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v8
>
> Changes from v7 to v8:
>
> - split overlayfs.c into smaller files
>
> - fix locking for copy up (reported by Al Viro)
>
> - locking analysis of copy up vs. directory rename added as a comment
>
> - tested with lockdep, fixed one lock annotation
>
> - other bug fixes
>
> To be done:
>
> - redo i_op->open, waiting for status of atomic_open() from Al
>
> - look into xattr support for tmpfs
>

What's still required for overlayfs to get into the kernel?

With the additional patches posted in the v8 branch (the modular build
fix and the xattr for tmpfs patch) overlayfs works for me.

I rebuilt my linux rescue system to use
overlayfs/tmpfs+squashfs/loop/fuse.httpfs and used it a few times
without any issues.

This system has about 1.6G data in 68599 files, 6960 directories and
7634 symlinks (compressed to about 630M squashfs).

Thanks

Michal
