Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187Ab0JHOgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:36:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33128 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758041Ab0JHOgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:36:45 -0400
Date: Fri, 8 Oct 2010 10:36:42 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>, Kyle McMartin <kyle@mcmartin.ca>,
        linux-kbuild@vger.kernel.org, aris@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] kbuild: fix oldnoconfig to do the right thing
Message-ID: <20101008143642.GA24144@bombadil.infradead.org>
References: <20100901152130.GY2684@bombadil.infradead.org>
 <20100905061758.GA29547@merkur.ravnborg.org>
 <20100908115553.GC2617@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100908115553.GC2617@sepie.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 01:55:53PM +0200, Michal Marek wrote:
> I found that when running make oldnoconfig on the kconfig branch of
> kbuild.git (which is currently a 2.6.35 + kconfig changes) against a
> 2.6.35-rc1 x86_64 defconfig, it mysteriously switches from
> CONFIG_KERNEL_GZIP=y to CONFIG_KERNEL_LZO=y. With Kyle's patch it
> doesn't do this. I applied the patch now.
> 

Hi Michal,

Can we get this sent to Linus before 2.6.36? It would be awkward to
release 2.6.36 with oldnoconfig working the broken way, and then patch
it after release.

--Kyle
