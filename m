Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab1LERMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:12:18 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50260 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523Ab1LERMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:12:16 -0500
Date: Mon, 5 Dec 2011 09:12:09 -0800
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@redhat.com, jonas@southpole.se, lennox.wu@gmail.com,
        sfr@canb.auug.org.au
Subject: Re: [PATCHSET tip:x86/memblock] memblock: Kill early_node_map[],
 take 2
Message-ID: <20111205171209.GA627@google.com>
References: <1322508685-32532-1-git-send-email-tj@kernel.org>
 <20111205163148.GA25909@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111205163148.GA25909@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Stephen, hi!)

On Mon, Dec 05, 2011 at 05:31:48PM +0100, Ingo Molnar wrote:
> * Tejun Heo <tj@kernel.org> wrote:
> 
> > Hello,
> > 
> > This patchset was posted quite a while ago but got lost during the
> > korg disturbance and I forgot about it too.  Thankfully, benh pinged
> > me about testing this patchset yesterday, so here's the refreshed
> > version.
> 
> A bit scary - you should get it into linux-next i suspect - if 
> that works out then we could then put it into tip:core/memblock 
> if there are no objections from anyone.
> 
> It's not really an x86 tree and most of the changes are 
> affecting non-x86 architectures, right?

Hmmm... this was part of the memblock updates going through
x86/memblock and unless we're gonna setup a separate tree for memblock
(I don't think that would be necessary at this point) I think it would
be better to route this x86/memblock eventually.  That said, setting
up temp linux-next branch for now sounds fine to me.  hpa, what do you
think?

Thanks.

-- 
tejun
