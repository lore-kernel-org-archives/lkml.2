Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab1EDVpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 17:45:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753818Ab1EDVpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 17:45:03 -0400
Date: Wed, 4 May 2011 14:44:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Righi <andrea@betterlinux.com>
Cc: Dave Chinner <david@fromorbit.com>, Mike Frysinger <vapier@gentoo.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fadvise: introduce POSIX_FADV_DONTNEED_FS
Message-Id: <20110504144411.7f32c00c.akpm@linux-foundation.org>
In-Reply-To: <1303928027-5100-1-git-send-email-andrea@betterlinux.com>
References: <1303928027-5100-1-git-send-email-andrea@betterlinux.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 20:13:47 +0200
Andrea Righi <andrea@betterlinux.com> wrote:

> Introduce a new fadvise flag to drop page cache pages of a single
> filesystem.

I'm going to object to this on general principle.  We shouldn't toss
new features into the kernel API just because we can.  Each feature
needs a really good argument to justify its inclusion, and I don't
believe that the case has been made for this feature.

IOW, who's going to die if we don't merge it?
