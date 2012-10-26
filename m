Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab2JZNnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 09:43:55 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64518 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932956Ab2JZNnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 09:43:52 -0400
Date: Fri, 26 Oct 2012 14:38:44 +0100
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RESEND PATCH 1/4] asm-generic: io: remove {read,write} string
 functions
Message-ID: <20121026133843.GL20914@mudshark.cambridge.arm.com>
References: <1350488704-3711-1-git-send-email-will.deacon@arm.com>
 <1350488704-3711-2-git-send-email-will.deacon@arm.com>
 <201210261329.03386.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210261329.03386.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 02:29:03PM +0100, Arnd Bergmann wrote:
> On Wednesday 17 October 2012, Will Deacon wrote:
> > The {read,write}s{b,w,l} functions are not defined across all
> > architectures and therefore shouldn't be used by portable drivers. We
> > should encourage driver writers to use the io{read,write}{8,16,32}_rep
> > functions instead.
> > 
> > This patch removes the {read,write} string functions for the generic IO
> > header as they have no place in a new architecture port.
> > 
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Mike Frysinger <vapier@gentoo.org>
> > Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Cheers Arnd!

> What should we do with the series? I can take them through the asm-generic
> tree if you like, or we can let Catalin take them through the arm64 tree.

Can you take patch 2/4 via asm-generic please? I'll respin the rest of the
series and try and update some more drivers in the process so that the
removal of the generic stream functions doesn't cause breakage for drivers
that aren't arch-specific already.

Thanks,

Will
