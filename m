Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab1I2XyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 19:54:13 -0400
Received: from sh.osrg.net ([192.16.179.4]:38784 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab1I2XyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:54:12 -0400
Date: Fri, 30 Sep 2011 08:49:38 +0900
To: konrad.wilk@oracle.com
Cc: linux-kernel@vger.kernel.org, thellstrom@vmware.com,
        dri-devel@lists.freedesktop.org, bskeggs@redhat.com,
        j.glisse@redhat.com, thomas@shipmail.org, airlied@redhat.com,
        airlied@linux.ie, alexdeucher@gmail.com, xen-devel@lists.xensource.com,
        fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 4/9] swiotlb: Expose swiotlb_nr_tlb function to modules
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1317328432-25620-5-git-send-email-konrad.wilk@oracle.com>
References: <1317328432-25620-1-git-send-email-konrad.wilk@oracle.com>
	<1317328432-25620-5-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110930083651R.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 30 Sep 2011 08:49:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011 16:33:47 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> As a mechanism to detect whether SWIOTLB is enabled or not.
> We also fix the spelling - it was swioltb instead of
> swiotlb.
> 
> CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> [v1: Ripped out swiotlb_enabled]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/swiotlb-xen.c |    2 +-
>  include/linux/swiotlb.h   |    2 +-
>  lib/swiotlb.c             |    5 +++--
>  3 files changed, 5 insertions(+), 4 deletions(-)

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
