Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab0HBQCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:02:08 -0400
Received: from sh.osrg.net ([192.16.179.4]:40880 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887Ab0HBQCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:02:03 -0400
Date: Tue, 3 Aug 2010 01:01:08 +0900
To: hpa@zytor.com
Cc: fujita.tomonori@lab.ntt.co.jp, jeremy@goop.org, Ian.Campbell@citrix.com,
        konrad.wilk@oracle.com, albert_herranz@yahoo.es, x86@kernel.org,
        linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        iommu@lists.linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH 9/9] x86: Detect whether we should use Xen SWIOTLB.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4C56E8A9.1060004@zytor.com>
References: <4C56E49E.6070102@zytor.com>
	<20100803004252B.fujita.tomonori@lab.ntt.co.jp>
	<4C56E8A9.1060004@zytor.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100803010025R.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 03 Aug 2010 01:01:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Aug 2010 08:47:53 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 08/02/2010 08:43 AM, FUJITA Tomonori wrote:
> > 
> > That's the difficult part because IOMMUs are not
> > interdependent. Hardware IOMMUs are related with swiotlb. GART and
> > AMD-IOMMU are too.
> > 
> > We could invent sorta IOMMU register interface and driver-ize IOMMUs
> > but they can't be interdependent completely.
> 
> Of course.  However, we need there to be as much structure to it as
> there can be.

Ok, let's see if Konrad can invent something clean.

But his attempt to create "swiotlb iommu function array" and "hardware
iommu function array" looks like to makes the code more unreadable.
