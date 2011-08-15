Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1HOOsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:48:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37409 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab1HOOsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:48:38 -0400
Subject: Re: [PULL] lguest fix, virtio documentation
From: Sasha Levin <levinsasha928@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <87sjp37au3.fsf@rustcorp.com.au>
References: <87sjp37au3.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 15 Aug 2011 17:48:32 +0300
Message-ID: <1313419712.3004.1.camel@sasha>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-15 at 10:25 +0930, Rusty Russell wrote:
> [ This adds a text copy of the virtio draft spec to the kernel source,
>   which should make it easier for people to find and read.  The master
>   is still the lyx document on my server, so I'll keep it in sync. ]
> 
> The following changes since commit 91d85ea6786107aa2837bef3e957165ad7c8b823:
> 
>   Merge branch 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging (2011-08-13 18:37:28 -0700)
> 
> are available in the git repository at:
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master
> 
> Rusty Russell (2):
>       virtio: Add text copy of spec to Documentation/virtual.

The "Device Status" paragraph says FAILED is 8, while it should be 0x80.

-- 

Sasha.

