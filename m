Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab0FNAg4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 20:36:56 -0400
Received: from sh.osrg.net ([192.16.179.4]:34841 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005Ab0FNAgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 20:36:51 -0400
Date: Mon, 14 Jun 2010 09:35:59 +0900
To: catalin.marinas@arm.com
Cc: npiggin@suse.de, hancockrwd@gmail.com, tj@kernel.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       colin.tuckley@arm.com, jeff@garzik.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] sata_sil24: Use memory barriers before issuing
 commands
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1276249306.12258.38.camel@e102109-lin.cambridge.arm.com>
References: <20100611013829.GB16436@laptop>
	<1276249306.12258.38.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100614093444O.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 14 Jun 2010 09:36:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 10:41:46 +0100
Catalin Marinas <catalin.marinas@arm.com> wrote:

> On Fri, 2010-06-11 at 02:38 +0100, Nick Piggin wrote:
> > On Thu, Jun 10, 2010 at 06:43:03PM -0600, Robert Hancock wrote:
> > > IMHO, it would be better for the platform code to ensure that MMIO
> > > access was strongly ordered with respect to each other and to RAM
> > > access. Drivers are just too likely to get this wrong, especially
> > > when x86, the most tested platform, doesn't have such issues.
> > 
> > The plan is to make all platforms do this. writes should be
> > strongly ordered with memory. That serves to keep them inside
> > critical sections as well.
> 
> Are there any public references to this discussion? Maybe a
> Documentation/ file (or update the memory-barriers.txt one would be
> useful).

I guess,

http://marc.info/?t=121185223900001&r=1&w=2
