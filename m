Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab0G2Joy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 05:44:54 -0400
Received: from sh.osrg.net ([192.16.179.4]:50878 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490Ab0G2Jou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 05:44:50 -0400
Date: Thu, 29 Jul 2010 18:44:13 +0900
To: Joerg.Roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, arnd@arndb.de, stepanm@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        dwalker@codeaurora.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100729092821.GP26098@amd.com>
References: <20100729090607.GN26098@amd.com>
	<20100729181412H.fujita.tomonori@lab.ntt.co.jp>
	<20100729092821.GP26098@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100729184336N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 29 Jul 2010 18:44:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010 11:28:21 +0200
"Roedel, Joerg" <Joerg.Roedel@amd.com> wrote:

> On Thu, Jul 29, 2010 at 05:14:49AM -0400, FUJITA Tomonori wrote:
> > Well, the reason (nobody has tried) might be that linux/iommu.h
> > doesn't look something intended for the generic IOMMU-API.
> 
> Oh, and as an additional note, the reason might also be that people were
> not aware of its existence :-)

No. People actually read it and think that it's not intended for
generic purposes, i.e., it was designed for VT-d/AMD-IOMMU with KVM:

http://lkml.org/lkml/2010/7/28/470

You designed it for what you need at the time. It should have been
named appropriately to avoid confusion. Later, when we actually
understand what other IOMMUs need, we can evolve the specific API for
generic purposes. Then we can rename the API to more generic.
