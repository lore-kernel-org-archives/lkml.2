Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab2JOE4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 00:56:00 -0400
Received: from linux-sh.org ([111.68.239.195]:49099 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab2JOEz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 00:55:59 -0400
Date: Mon, 15 Oct 2012 13:55:51 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for sh [ver #2]
Message-ID: <20121015045550.GF3192@linux-sh.org>
References: <21197.1349774157@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21197.1349774157@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 10:15:57AM +0100, David Howells wrote:
> Can you merge the following branch into the sh tree please.
> 
> This is to complete part of the UAPI disintegration for which the preparatory
> patches were pulled recently.
> 
> Now that the fixups and the asm-generic chunk have been merged, I've
> regenerated the patches to get rid of those dependencies and to take account of
> any changes made so far in the merge window.  If you have already pulled the
> older version of the branch aimed at you, then please feel free to ignore this
> request.
> 
> The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74a8:
> 
>   Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)
> 
> are available in the git repository at:
> 
> 
>   git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-sh-20121009
> 
Pulled, thanks.
