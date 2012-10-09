Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab2JIDgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 23:36:33 -0400
Received: from void.printf.net ([89.145.121.20]:50780 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab2JIDgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 23:36:31 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: Re: [GIT PULL] MMC updates for 3.7-rc1
References: <87a9vxdsia.fsf@octavius.laptop.org>
Date: Mon, 08 Oct 2012 23:36:25 -0400
In-Reply-To: <87a9vxdsia.fsf@octavius.laptop.org> (Chris Ball's message of
	"Mon, 08 Oct 2012 09:04:45 -0400")
Message-ID: <87pq4sco5i.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Oct 08 2012, Chris Ball wrote:
> Please pull from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-merge-for-3.7-rc1
>
> to receive the MMC merge for 3.7.  There are currently two conflicts
> due to header renames for the ARM single zImage work; they should be
> resolved by taking the changes already in your tree.  Thanks.

Sorry, the merge isn't so one-sided -- here's my resolution for you to
compare with:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-merge-for-3.7-rc1-merged

davinci_mmc.c now uses <linux/edma.h> which is provided by a commit
in the slave-dmaengine tree, which hasn't sent in a pull request yet.
Vinod, please can you do that soon?

Let me know if I should do anything else.  Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
