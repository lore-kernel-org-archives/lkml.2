Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab2JEUQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 16:16:16 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:60140 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751889Ab2JEUQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 16:16:14 -0400
Message-ID: <506F4001.4070006@xenotime.net>
Date: Fri, 05 Oct 2012 13:16:01 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>
Subject: Re: linux-next: Tree for Oct 5 (nouveau)
References: <20121005145417.7c466395ef77a9f15c1eebaa@canb.auug.org.au>
In-Reply-To: <20121005145417.7c466395ef77a9f15c1eebaa@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 09:54 PM, Stephen Rothwell wrote:

> Hi all,
> 
> Do not add stuff destined for v3.8 to your linux-next included branches
> until after v3.7-rc1 is released.
> 
> Changes since 201201004:
> 


on x86_64, when CONFIG_AGP is not enabled:

  CC [M]  drivers/gpu/drm/nouveau/nouveau_bo.o
drivers/gpu/drm/nouveau/nouveau_bo.c: In function 'nouveau_ttm_tt_create':
drivers/gpu/drm/nouveau/nouveau_bo.c:463:3: error: implicit declaration of function 'ttm_agp_tt_create'
drivers/gpu/drm/nouveau/nouveau_bo.c:463:3: warning: return makes pointer from integer without a cast
make[5]: *** [drivers/gpu/drm/nouveau/nouveau_bo.o] Error 1


-- 
~Randy
