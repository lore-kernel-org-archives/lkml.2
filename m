Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786Ab0IHNBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:01:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34935 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab0IHNB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:01:26 -0400
Date: Wed, 8 Sep 2010 09:01:22 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>, Kyle McMartin <kyle@mcmartin.ca>,
        linux-kbuild@vger.kernel.org, aris@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: fix oldnoconfig to do the right thing
Message-ID: <20100908130122.GB24791@bombadil.infradead.org>
References: <20100901152130.GY2684@bombadil.infradead.org>
 <20100905061758.GA29547@merkur.ravnborg.org>
 <20100908115553.GC2617@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100908115553.GC2617@sepie.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
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

Yes, sorry, I had meant to followup with a diff of the resulting
configs. I noticed without the patch, that menu config options, like the
i386 processor selection, or the compression type, were getting set
incorrectly despite being set in the input oldconfig correctly.

Thanks Michal and Sam for the review!
	Kyle
