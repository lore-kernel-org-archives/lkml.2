Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab2AIALl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 19:11:41 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40032 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab2AIALj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 19:11:39 -0500
MIME-Version: 1.0
In-Reply-To: <20120108235338.GR23916@ZenIV.linux.org.uk>
References: <20120105022318.GG23916@ZenIV.linux.org.uk> <CA+55aFw+7xvfP3NCr5p2Ma--UTb7zT+QQxtjCn3V2SU_g3LUdA@mail.gmail.com>
 <20120108235039.GQ23916@ZenIV.linux.org.uk> <20120108235338.GR23916@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 8 Jan 2012 16:11:17 -0800
X-Google-Sender-Auth: EIwCA_whcmQiJZosZnDBHkD_m48
Message-ID: <CA+55aFzqfne7xs-M3qkZYs=wFmCJBL43AFcywRg3dc1S=8qK6A@mail.gmail.com>
Subject: Re: [git pull] vfs pile 1
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <mszeredi@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 8, 2012 at 3:53 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> ... and sure enough, ext3 has the same piece of fun.

Hmm. Do we want to have the s_remove_count games for this "temporarily
zero nlink" case? Maybe we don't want to do drop_nlink/set_nlink? Does
it matter?

Anyway, mind sending me a patch with changelog and sign-off?

                       Linus
