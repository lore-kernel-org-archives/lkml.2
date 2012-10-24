Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161464Ab2JXW27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:28:59 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:63285 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161356Ab2JXW25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:28:57 -0400
Date: Wed, 24 Oct 2012 15:28:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Omar Ramirez Luna <omar.ramirez@copitl.com>
Cc: Victor Manuel Jaquez Leal <vjaquez@igalia.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] staging: tidspbridge fixes for 3.7
Message-ID: <20121024222854.GA1891@kroah.com>
References: <1351116560-6918-1-git-send-email-omar.ramirez@copitl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351116560-6918-1-git-send-email-omar.ramirez@copitl.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 05:09:14PM -0500, Omar Ramirez Luna wrote:
> With 3.7-rc1 changes:
> 
> - New irq numbering in OMAP3 broke the driver request for a mmu irq,
>   until this is migrated to the common iommu framework we can only
>   hardcode the new number.
> - _raw_* accessors changed a type of one of their parameters with patch
>   "195bbca ARM: 7500/1: io: avoid writeback addressing modes for
>   __raw_ accessors", so the build system was filled with warnings from
>   the old parameter usage.
> 
> Omar Ramirez Luna (6):
>   staging: tidspbridge: request the right irq for mmu
>   staging: tidspbridge: drop const from custom mmu implementation
>   staging: tidspbridge: change type to __iomem for per and core
>     addresses
>   staging: tidspbridge: ioremap dsp sync addr
>   staging: tidspbridge: ioremap physical address of the stack segment
>     in shm
>   staging: tidspbridge: delete unused mmu functions

Are the "fix up the compiler warning" patches really needed for 3.7?
Are they new in 3.7-rc1?  Or were they there before in 3.6?

thanks,

greg k-h
