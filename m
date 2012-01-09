Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab2AIAjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 19:39:45 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51434 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab2AIAjn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 19:39:43 -0500
MIME-Version: 1.0
In-Reply-To: <20120109002526.GS23916@ZenIV.linux.org.uk>
References: <20120105022318.GG23916@ZenIV.linux.org.uk> <CA+55aFw+7xvfP3NCr5p2Ma--UTb7zT+QQxtjCn3V2SU_g3LUdA@mail.gmail.com>
 <20120108235039.GQ23916@ZenIV.linux.org.uk> <20120108235338.GR23916@ZenIV.linux.org.uk>
 <CA+55aFzqfne7xs-M3qkZYs=wFmCJBL43AFcywRg3dc1S=8qK6A@mail.gmail.com> <20120109002526.GS23916@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 8 Jan 2012 16:39:20 -0800
X-Google-Sender-Auth: ytNsYZXolHmWlyiugU3mQlfXRMU
Message-ID: <CA+55aFyoUokxXEU7QDMxyXEss9Xp-XsY-cz1QPC442xZKcuXjg@mail.gmail.com>
Subject: Re: [git pull] vfs pile 1
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <mszeredi@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 8, 2012 at 4:25 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Sure, will do.  I have several more fixes in my tree right now (including
> such gems as double kfree() in devpts on mount failure ;-/), so I'll send
> a pull request in a couple of hours anyway.  Would you be OK with having
> that patch in the same pile?

Sure, no problem.

                Linus
