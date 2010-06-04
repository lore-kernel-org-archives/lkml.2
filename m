Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab0FDVc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 17:32:56 -0400
Received: from king.tilera.com ([72.1.168.226]:44609 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab0FDVcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 17:32:54 -0400
Message-ID: <4C097104.3080406@tilera.com>
Date: Fri, 04 Jun 2010 17:32:52 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 0/8] revised patch for arch/tile/ support
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <201005290333.o4T3Xjse029917@farm-0002.internal.tilera.com> <201005291329.10941.arnd@arndb.de> <201006032240.31963.arnd@arndb.de>
In-Reply-To: <201006032240.31963.arnd@arndb.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jun 2010 21:32:53.0993 (UTC) FILETIME=[7DBF7590:01CB042D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/3/2010 4:40 PM, Arnd Bergmann wrote:
> You evidently didn't make it into -rc1, probably because Linus considered
> your submission to be too late, or possibly because some of the bigger
> patches got lost in an email filter.
>
> To go forward with your architecture, I suggest that you start adding it
> to the linux-next tree. Until you have a git tree, the easiest way
> to do that is to put a tarball in quilt format at a http url under
> your control, and ask Stephen to include that.
>   

I've set up a GIT tree for the Tilera architecture support here:

git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git

I kept the commit to fix up the "generic" unistd.h ABI and added Arnd's
Acked-by to the commit message, and I combined the v2 Tilera-specific
series of patches along with responses to the v2 patches into a single
commit, with appropriate Acked-by and Reviewed-by based on what folks
had said.

Stephen, in an ideal world you could add this repository to your set of
things you pull from into linux-next, and going forward I would then be
the gatekeeper for "arch/tile/" changes.  I'll plan to continue mailing
the diffs to LKML for public review, and push them up to git.kernel.org
after feedback has died down and they are ready to go to linux-next. 
Does that sound good to you?

Many thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


