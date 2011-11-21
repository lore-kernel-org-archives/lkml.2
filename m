Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab1KUGGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 01:06:47 -0500
Received: from ozlabs.org ([203.10.76.45]:51931 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab1KUGGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 01:06:46 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] missing dependency for virtio_mmio
In-Reply-To: <20111121035831.GF2203@ZenIV.linux.org.uk>
References: <20111121035831.GF2203@ZenIV.linux.org.uk>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 21 Nov 2011 15:56:45 +1030
Message-ID: <874nxy9hbe.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011 03:58:31 +0000, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> Driver really depends on having readb/writeb/etc. - won't even build on
> things like s390 or uml and on tile without PCI it'll build but panic
> if you manage to run it...

Thanks, already queued.  I was about to send it when YA virtio fix
turned up, and I like them to sit in linux-next for a cycle first.

That said, happy for Linus to take this now if it's breaking people.

Cheers,
Rusty.
