Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab0EQJt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:49:27 -0400
Received: from sh.osrg.net ([192.16.179.4]:60740 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab0EQJt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:49:26 -0400
Date: Mon, 17 May 2010 18:48:35 +0900
To: konrad.wilk@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com, jeremy@goop.org,
       dwmw2@infradead.org
Subject: Re: [PATCH] swiotlb v0.8: seperation of physical/virtual address
 translation
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1273592353-23224-1-git-send-email-konrad.wilk@oracle.com>
References: <1273592353-23224-1-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100517185011X.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 17 May 2010 18:48:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 11:39:07 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git swiotlb-0.8
> 
>  include/linux/swiotlb.h |   27 ++++++++-
>  lib/swiotlb.c           |  140 ++++++++++++++++++++++++++++-------------------
>  2 files changed, 108 insertions(+), 59 deletions(-)

I think that the 5th and 6th should be fold. But the rest (with the
following fixes) looks fine to me. I'm not sure how you send this to
upstream, however, seems that the patchset conflicts with the swiotlb
changes in -mm.
