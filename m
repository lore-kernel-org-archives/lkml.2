Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712Ab0GVHvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 03:51:07 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:39421 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011Ab0GVHvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 03:51:02 -0400
Message-ID: <4C47F861.8080501@linux.vnet.ibm.com>
Date: Thu, 22 Jul 2010 13:20:57 +0530
From: divya <dipraksh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        David Airlie <airlied@linux.ie>
Subject: build failure with kernel 2.6.35-rc5-git6/git7 on power box
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The kernel versions 2.6.35-rc5-git6(commitid f4b23cc2d5dc78ef) and 2.6.35-rc5-git7(commitid cd5b8f8755a89a5) fails
to build on power6 and power5 machines with the following error


   drivers/gpu/drm/ttm/ttm_page_alloc.c: In function 'set_pages_array_wb':
   drivers/gpu/drm/ttm/ttm_page_alloc.c:227: error: implicit declaration of function 'unmap_page_from_agp'
   drivers/gpu/drm/ttm/ttm_page_alloc.c: In function 'set_pages_array_wc':
   drivers/gpu/drm/ttm/ttm_page_alloc.c:238: error: implicit declaration of function 'map_page_into_agp'
   drivers/gpu/drm/ttm/ttm_page_alloc.c: In function 'ttm_pool_mm_shrink_init':
   drivers/gpu/drm/ttm/ttm_page_alloc.c:419: warning: assignment from incompatible pointer type
   make[4]: *** [drivers/gpu/drm/ttm/ttm_page_alloc.o] Error 1
   make[3]: *** [drivers/gpu/drm/ttm] Error 2

Thanks
Divya

