Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934200Ab2JLR1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 13:27:43 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54837
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934163Ab2JLR1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 13:27:42 -0400
Date: Fri, 12 Oct 2012 13:27:36 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
Message-ID: <20121012172736.GA15650@infradead.org>
References: <alpine.LFD.2.02.1210121434140.10531@tux.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1210121434140.10531@tux.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 02:34:33PM +0300, Pekka Enberg wrote:
> Hi Linus,
> 
> Please consider pulling the latest LKVM tree from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git kvmtool/for-linus
> 
> LKVM is the long lost userspace friend of KVM that makes it really easy
> to launch virtualized Linx environment on x86 and PPC64 Linux.

This still doesn't have any business in the kernel tree.  I also can't
remember than any new arguments came up why this should be merged vs
the arguments why it's been reject over and over again.

