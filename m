Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab1FTLRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 07:17:05 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46973
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751139Ab1FTLRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 07:17:02 -0400
Date: Mon, 20 Jun 2011 07:16:58 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, hch@infradead.org
Subject: Re: [PATCHSET] ptrace: kill most tracehooks
Message-ID: <20110620111658.GA19720@infradead.org>
References: <1308322240-8247-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308322240-8247-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 04:50:33PM +0200, Tejun Heo wrote:
> Hello,
> 
> At this point, tracehooks aren't useful to mainline kernel and mostly
> just add an extra layer of obfuscation.  Although they have comments,
> without actual in-kernel users, it is difficult to tell what are their
> assumptions and they're actually trying to achieve.  To mainline
> kernel, they just aren't worth keeping around.
> 
> This patchset kills most tracehooks which aren't used from arch codes.
> The remaining ones will be dealt with with future changes.

Thanks, this makes the whole ptrace interaction a lot more sensible and
actually possible to follow.

