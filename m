Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab1CQNPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 09:15:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:55529 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab1CQNPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 09:15:09 -0400
Date: Thu, 17 Mar 2011 14:15:08 +0100
From: Michal Marek <mmarek@suse.cz>
To: matt mooney <mfm@muteddisk.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 00/27] update makefiles to use the newer flag
 variables
Message-ID: <20110317131508.GB30807@sepie.suse.cz>
References: <cover.1295006561.git.mfm@muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1295006561.git.mfm@muteddisk.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 06:12:23AM -0800, matt mooney wrote:
> Hi Michal,
> 
> These are the patches that never made their way into the linux-next tree.
> I have added all of the acks that came through.
> 
> Thanks,
> matt
> 
> 
> matt mooney (27):
>   kernel: change to new flag variable
>   alpha: change to new flag variables
>   arm: change to new flag variables
>   h8300: change to new flag variable
>   ia64: change to new flag variables
>   m68k: change to new flag variables
>   microblaze: change to new flag variable
>   mips: change to new flag variable
>   s390: change to new flag variable
>   um: change to new flag variables
>   xtensa: change to new flag variable
>   fs: change to new flag variable
>   char: change to new flag variable
>   dma: change to new flag variable
>   hwmon: change to new flag variable
>   ide: change to new flag variable
>   ieee802154: change to new flag variable
>   isdn: change to new flag variable
>   memstick: change to new flag variable
>   message: change to new flag variable
>   misc: change to new flag variable
>   net: change to new flag variable
>   pps: change to new flag variable
>   rapidio: change to new flag variable
>   rtc: change to new flag variable
>   scsi: change to new flag variable
>   video: change to new flag variable

I committed these to kbuild.2.6.git#trivial and will send a pull request
to Linus.

Thanks,
Michal
