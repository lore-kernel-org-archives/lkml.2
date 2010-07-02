Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab0GBHAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 03:00:46 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:55977 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab0GBHAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:00:45 -0400
Date: Fri, 2 Jul 2010 16:00:01 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Zach Pfeffer <zpfeffer@codeaurora.org>
Cc: Randy Dunlap <randy.dunlap@Oracle.COM>, mel@csn.ul.ie, andi@firstfloor.org,
       dwalker@codeaurora.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
       linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 1/3] mm: iommu: An API to unify IOMMU, CPU and device memory management
Message-ID: <20100702070001.GA25679@linux-sh.org>
References: <1277877350-2147-1-git-send-email-zpfeffer@codeaurora.org> <20100630164058.aa6aa3a2.randy.dunlap@oracle.com> <4C2C40C2.50106@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2C40C2.50106@codeaurora.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 12:16:18AM -0700, Zach Pfeffer wrote:
> Thank you for the corrections. I'm correcting them now. Some responses:
> 
> Randy Dunlap wrote:
> >> +    struct vcm *vcm_create(size_t start_addr, size_t len);
> > 
> > Seems odd to use size_t for start_addr.
> 
> I used size_t because I wanted to allow the start_addr the same range
> as len. Is there a better type to use? I see 'unsigned long' used
> throughout the mm code. Perhaps that's better for both the start_addr
> and len.
> 
phys_addr_t or resource_size_t.
