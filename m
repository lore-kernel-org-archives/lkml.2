Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335Ab0JIROv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 13:14:51 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:58353 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab0JIROu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 13:14:50 -0400
Date: Sat, 9 Oct 2010 11:14:47 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] fs: introduce a per-cpu last_ino allocator
Message-ID: <20101009171447.GF10421@parisc-linux.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com> <1286515292-15882-16-git-send-email-david@fromorbit.com> <20101008095658.GA19804@ZenIV.linux.org.uk> <20101008100346.GA27737@infradead.org> <1286533219.2959.128.camel@edumazet-laptop> <20101008134821.GA15157@infradead.org> <1286546772.2959.372.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286546772.2959.372.camel@edumazet-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:06:12PM +0200, Eric Dumazet wrote:
> Maybe finally generate 64bit inum on 64bit arches...

Last I heard, Eric Sandeen took a look at this, and it'd break something
like 30-40% of the userspace shipped in RHEL 5 if run as 32-bit on a
64-bit kernel.  IOW, keep inode numbers to 32-bit for now.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
