Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab0KJP7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:59:15 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34839 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab0KJP7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:59:14 -0500
Date: Wed, 10 Nov 2010 08:59:10 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Michal Simek <monstr@monstr.eu>
Cc: John Linn <John.Linn@xilinx.com>, spi-devel-general@lists.sourceforge.net,
        richard.rojfors@mocean-labs.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] spi/xilinx: Merge OF and non-OF drivers
Message-ID: <20101110155910.GC2266@angua.secretlab.ca>
References: <20101014161724.18966.42340.stgit@localhost6.localdomain6>
 <4CD7FB27.9030804@monstr.eu>
 <ec622bb7-57d1-4aa2-80f1-65fa4b3fa7eb@VA3EHSMHS033.ehs.local>
 <AANLkTinMoqqMKeEFiD=xHwa5DS+5qY6xN2r236SZQEba@mail.gmail.com>
 <4CDA9BAE.6020709@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDA9BAE.6020709@monstr.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 02:18:38PM +0100, Michal Simek wrote:
> Grant Likely wrote:
> >On Mon, Nov 8, 2010 at 9:34 AM, John Linn <John.Linn@xilinx.com> wrote:
> >>>-----Original Message-----
> >>>From: Michal Simek [mailto:monstr@monstr.eu]
> >>>Sent: Monday, November 08, 2010 6:29 AM
> >>>To: grant.likely@secretlab.ca
> >>>Cc: spi-devel-general@lists.sourceforge.net; richard.rojfors@mocean-labs.com; John Linn; linux-
> >>>kernel@vger.kernel.org
> >>>Subject: Re: [RFC PATCH 0/3] spi/xilinx: Merge OF and non-OF drivers
> >>>
> >>>Hi Grant,
> >>>
> >>>Grant Likely wrote:
> >>>>Since of_platform_bus_type has been merged with the platform_bus_type,
> >>>>a single platform driver can now support both use cases.  This patch
> >>>>series merges the two halves of the xilinx_spi device driver.
> >>>>
> >>>>Compile tested only.  I haven't booted this yet.
> >>>I have tested it on sp605 and works well. Have you added that patches
> >>>to your repository? Or are they somewhere else? Who is responsible for?
> 
> Grant: Can you answer my questions?
> 
> That our patch about DMA should follow your three patches.

It is in my spi/next branch which I haven't pushed out to my public
tree yet.  Sometime today I will after I've given it one more run
through.

g.

