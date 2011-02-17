Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab1BQQVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 11:21:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002Ab1BQQVW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 11:21:22 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=50m7xULN+Mob1942b+qBEgMcqUPDWSd3inan6@mail.gmail.com>
References: <AANLkTi=50m7xULN+Mob1942b+qBEgMcqUPDWSd3inan6@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Feb 2011 08:20:31 -0800
Message-ID: <AANLkTim2fg5OUw2aZXA-4V4O7PUQ6T4mhoWxvjNdtYcc@mail.gmail.com>
Subject: Re: [PATCH] code cleanup on fs/super.c
To: Steven Liu <lingjiujianke@gmail.com>
Cc: viro@zeniv.linux.org.uk, randy.dunlap@oracle.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dchinner@redhat.com, liuqi <liuqi@thunderst.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 12:59 AM, Steven Liu <lingjiujianke@gmail.com> wrote:
>
>   Clean up the unsed code on fs/super.c, all filesystem using mount_bdev
>   and mount_nodev to replace get_sb_bdev and get_sb_nodev.

There might easily be external modules that still use this.

Also, if you do this, then the same patch would also need to remove
the declarations and the documentation entry, so that there is no sign
at all of those functions in the whole kernel tree.

                       Linus
