Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab1CDG4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 01:56:54 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:32834 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab1CDG4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 01:56:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lmvJ8lSxjgEOOkhDa/1DUlK3TYuVmJyh77Fp2+5aYLqjj318CLy8hfxg/vlguXvYcx
         RtUpkuadx6UzkpGtyAU7hJUArYtMjlP73LcgjvvQcI7ojwhZ8ZiXbhAnW4xIMEso5R/5
         El6w2JFkPoRRnF8zd/ovVM2m0poCKdE+1bnEI=
Subject: Re: [PATCH] Syscalls: reboot: Add options to the reboot syscall to
 remount filesystems ro
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Lord <kernel@teksavvy.com>, Ken Sumrall <ksumrall@android.com>,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew@wil.cx>,
        Eric Paris <eparis@redhat.com>, Dave Young <hidave.darkstar@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, James Morris <jmorris@namei.org>,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <AANLkTimXhGRsuL3Z51msS_YEtsa4UZuN9XW8Xb+hu_KN@mail.gmail.com>
References: <1299137483-10975-1-git-send-email-ksumrall@android.com>
	 <AANLkTik1pNPzPqXaNrLNFnEt4+cknxYdOUwZ9Q=g5PCA@mail.gmail.com>
	 <4D6FDDB1.3060209@teksavvy.com>
	 <AANLkTimXhGRsuL3Z51msS_YEtsa4UZuN9XW8Xb+hu_KN@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 08:55:23 +0200
Message-ID: <1299221723.2735.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-03 at 15:36 -0800, Linus Torvalds wrote:
> But you're certainly right that it takes less code to open
> /proc/sysrq-trigger and writing a single byte to it than it does to do
> the straightforward "let's just do the normal mount thing".

/proc/sysrq-trigger is sometimes simply disabled for "security reasons".
I'm not sure about Android, but some systems I know do disable it. So I
think /proc/mounts is a cleaner approach.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

