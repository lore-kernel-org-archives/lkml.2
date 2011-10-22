Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab1JVFul (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:50:41 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:37940 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab1JVFuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:50:40 -0400
X-Greylist: delayed 2473 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Oct 2011 01:50:39 EDT
To: konrad.wilk@oracle.com
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        thellstrom@vmware.com, thomas@shipmail.org, airlied@redhat.com,
        xen-devel@lists.xensource.com, j.glisse@redhat.com, bskeggs@redhat.com,
        fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 01/11] swiotlb: Expose swiotlb_nr_tlb function to
 modules
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1319062772-2793-2-git-send-email-konrad.wilk@oracle.com>
References: <1319062772-2793-1-git-send-email-konrad.wilk@oracle.com>
	<1319062772-2793-2-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20111022134914N.fujita.tomonori@lab.ntt.co.jp>
Date: Sat, 22 Oct 2011 13:49:14 +0900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Oct 2011 18:19:22 -0400
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
