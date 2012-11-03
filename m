Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393Ab2KCAb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 20:31:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab2KCAb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 20:31:27 -0400
Date: Fri, 2 Nov 2012 22:31:10 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 0/4] 3.0.51-stable review
Message-ID: <20121103003108.GA1981@optiplex.redhat.com>
References: <20121102170333.581931288@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121102170333.581931288@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 10:06:04AM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.51 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun Nov  4 17:03:28 UTC 2012.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.51-rc1.gz
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 3.0.51-rc1
> 
> Ben Skeggs <bskeggs@redhat.com>
>     drm/nouveau: silence modesetting spam on pre-gf8 chipsets
> 
> Jan Kara <jack@suse.cz>
>     mm: fix XFS oops due to dirty pages without buffers on s390
> 

Howdy Greg,

Somehow the following patch is missing for this series submission:
> Len Brown <len.brown@intel.com>
>     x86: Remove the ancient and deprecated disable_hlt() and enable_hlt() facility

I glanced at the the downloadable consolidated patch and its hunks seem to be present,
though.

Cheers!
-- Rafael

> 
> Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
>     floppy: do put_disk on current dr if blk_init_queue fails
> 
> 
> -------------
> 
> Diffstat:
> 
>  Documentation/feature-removal-schedule.txt |  8 -------
>  Makefile                                   |  4 ++--
>  arch/x86/include/asm/system.h              |  7 ------
>  arch/x86/kernel/process.c                  | 24 -------------------
>  drivers/block/floppy.c                     | 37 +-----------------------------
>  drivers/gpu/drm/nouveau/nv04_dac.c         |  8 +++----
>  drivers/gpu/drm/nouveau/nv04_dfp.c         |  6 ++---
>  drivers/gpu/drm/nouveau/nv04_tv.c          |  4 ++--
>  mm/rmap.c                                  | 21 +++++++++++++----
>  9 files changed, 28 insertions(+), 91 deletions(-)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
