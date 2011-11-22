Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab1KVRs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:48:59 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61277 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab1KVRs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:48:58 -0500
MIME-Version: 1.0
In-Reply-To: <20111122174419.GI2203@ZenIV.linux.org.uk>
References: <20111122174419.GI2203@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 Nov 2011 09:48:36 -0800
X-Google-Sender-Auth: cVh5oSRv5bfgoirlel-LWgWlvkc
Message-ID: <CA+55aFz+9TN2z+q9vH2g0wMq6_X8AfYANrntGQd_et+U5+c74Q@mail.gmail.com>
Subject: Re: [git pull] vfs fix
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 9:44 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> Really embarrassing braino; kudos to jlayton for catching that one.
> Please, pull from
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
>
> Al Viro (1):
>      mount_subtree() pointless use-after-free

Hmm. That's not at all what I get.

Or rather, that's just *one* of the commits I get. I also get these two:

      microblaze: bury asm/namei.h
      iio: fix a leak due to improper use of anon_inode_getfd()

which look like they may be valid, but for all I know you meant to
leave them for the next merge window. So not pulled. Please check your
tree,

                Linus
