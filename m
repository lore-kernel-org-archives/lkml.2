Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab0GVEso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 00:48:44 -0400
Received: from sh.osrg.net ([192.16.179.4]:47585 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab0GVEsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 00:48:42 -0400
Date: Thu, 22 Jul 2010 13:47:36 +0900
To: zpfeffer@codeaurora.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux@arm.linux.org.uk,
        alan@lxorguk.ukuu.org.uk, randy.dunlap@oracle.com,
        dwalker@codeaurora.org, mel@csn.ul.ie, linux-arm-msm@vger.kernel.org,
        joro@8bytes.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        andi@firstfloor.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100722035026.GB14176@codeaurora.org>
References: <20100713090223.GB20590@n2100.arm.linux.org.uk>
	<20100714105922D.fujita.tomonori@lab.ntt.co.jp>
	<20100722035026.GB14176@codeaurora.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100722134708I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 22 Jul 2010 13:47:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jul 2010 20:50:26 -0700
Zach Pfeffer <zpfeffer@codeaurora.org> wrote:

> On Wed, Jul 14, 2010 at 10:59:43AM +0900, FUJITA Tomonori wrote:
> > On Tue, 13 Jul 2010 10:02:23 +0100
> > 
> > Zach Pfeffer said this new VCM infrastructure can be useful for
> > video4linux. However, I don't think we need 3,000-lines another
> > abstraction layer to solve video4linux's issue nicely.
> 
> Its only 3000 lines because I haven't converted the code to use
> function pointers.

The main point is adding a new abstraction that don't provide the huge
benefit.
