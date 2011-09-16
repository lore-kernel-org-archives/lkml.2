Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab1IPTKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 15:10:44 -0400
Received: from sh.osrg.net ([192.16.179.4]:50844 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab1IPTKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 15:10:43 -0400
Date: Sat, 17 Sep 2011 04:05:58 +0900
To: konrad.wilk@oracle.com
Cc: thellstrom@vmware.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, dri-devel@lists.freedesktop.org,
        thomas@shipmail.org, pq@iki.fi, bskeggs@redhat.com,
        j.glisse@redhat.com, airlied@redhat.com, airlied@linux.ie,
        alexdeucher@gmail.com, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 4/7] swiotlb: Expose swiotlb_nr_tlb function to modules
 as swiotlb_enabled
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1315923170-25568-5-git-send-email-konrad.wilk@oracle.com>
References: <1315923170-25568-1-git-send-email-konrad.wilk@oracle.com>
	<1315923170-25568-5-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110917035611F.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 17 Sep 2011 04:06:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Sep 2011 10:12:47 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> As a mechanism to detect whether SWIOTLB is enabled or not.
> And as such, we might as well wrap it within an 'swiotlb_enabled()'
> function that will call the swiotlb_nr_tlb.
> 
> We also fix the spelling - it was swioltb instead of
> swiotlb.
> 
> CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/swiotlb-xen.c |    2 +-
>  include/linux/swiotlb.h   |    7 ++++++-
>  lib/swiotlb.c             |    5 +++--
>  3 files changed, 10 insertions(+), 4 deletions(-)

Can we just use swiotlb_nr_tbl() rather than inventing a new function
that only wraps swiotlb_nr_tbl()?

