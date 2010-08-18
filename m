Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab0HRQp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:45:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699Ab0HRQp1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:45:27 -0400
MIME-Version: 1.0
In-Reply-To: <20100818153528.GO31363@ZenIV.linux.org.uk>
References: <20100818153528.GO31363@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 Aug 2010 09:44:34 -0700
Message-ID: <AANLkTi=BZ9bvP0LE_SYAvfAPA1PN-E0UQ3-Oo09Qkib3@mail.gmail.com>
Subject: Re: [git pull] vfs for rc2, part 1
To: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 8:35 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Jan Kara (1):
>      vfs: update ctime when changing the file's permission by setfacl

What dirties the inode for this case? It seems to just set i_ctime
directly, how does it actually get written back to disk?

Or is this purely a tmpfs/shmfs issue? Maybe a comment on that would
have been good.

Anyway, pulled. I may not get all the patches from Nick I want, but at
least I got some..

                          Linus
