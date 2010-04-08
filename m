Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967Ab0DHRQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 13:16:08 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:52911 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932943Ab0DHRQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 13:16:05 -0400
Date: Thu, 8 Apr 2010 13:14:42 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Konrad Rzeszutek Wilk <konrad@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Jones <pjones@redhat.com>, Jan Beulich <jbeulich@novell.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [LKML] Re: [PATCH 1/1] ibft, x86: Change reserve_ibft_region() to find_ibft_region()
Message-ID: <20100408171442.GA1216@andromeda.dapyr.net>
References: <1270741936-1306-1-git-send-email-konrad@kernel.org> <1270741936-1306-2-git-send-email-konrad@kernel.org> <alpine.LFD.2.00.1004080852200.3558@i5.linux-foundation.org> <20100408161210.GA13382@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100408161210.GA13382@phenom.dumpdata.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > For all I know this is all perfectly fine, but I have _no_ idea about how 
> > ibft is supposed to work, so I can't really judge it. As a result, I won't 
> > pull it without some more acks from people who actually know what that 
> > thing is..
> 
> Oh, I am definitely ACK-ing. Sorry about not explicitly stating that.
> The developer is Yinghai Lu, I am the co-maintainer of the iBFT driver.
> 
> Linus, would you like me to modify the commit so that it has 'Acked-by:'
> by me in the git tree?

I've gone ahead and done that. The git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft-2.6.git
ibft-fixes.acked

has the patch that was acked (and reviewed + tested on my iBFT rig)
by me.

(The ibft-fixes has the old commit, with the Signed-off-by instead of
Acked-by).

