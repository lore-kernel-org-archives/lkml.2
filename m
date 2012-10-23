Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970Ab2JWNMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:12:53 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49532
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753273Ab2JWNMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:12:51 -0400
Date: Tue, 23 Oct 2012 09:12:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Benjamin Poirier <bpoirier@suse.de>,
        Yaakov Selkowitz <yselkowitz@gmail.com>
Subject: Re: [PATCH] kconfig/menuconfig: use TAILQ instead of CIRCLEQ
Message-ID: <20121023131248.GA4289@infradead.org>
References: <1350581625-23153-1-git-send-email-yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350581625-23153-1-git-send-email-yann.morin.1998@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 07:33:45PM +0200, Yann E. MORIN wrote:
> Some systems (eg. Cygwin, FreeBSD) are missing the CIRCLEQ macros.
> They were removed in Y2000 from FreeBSD:
>     http://svnweb.freebsd.org/base?view=revision&revision=70469
> 
> The reason was that TAILQ are perfectly capable of doing the exact
> same things:
>     http://www.mavetju.org/mail/view_thread.php?list=freebsd-arch&id=915145&thread=yes
> 
> (Thank Yaakov for the pointers!)
> 
> So, switch to using TAILQ instead, which are more portable.

Why not use the kernels list.h?

