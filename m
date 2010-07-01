Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab0GAT2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 15:28:37 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60701 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab0GAT2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 15:28:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6030"; a="46056039"
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
From: Daniel Walker <dwalker@codeaurora.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Zach Pfeffer <zpfeffer@codeaurora.org>, mel@csn.ul.ie,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100701180241.GA3594@basil.fritz.box>
References: <1277877350-2147-1-git-send-email-zpfeffer@codeaurora.org>
	 <1277877350-2147-3-git-send-email-zpfeffer@codeaurora.org>
	 <20100701101746.3810cc3b.randy.dunlap@oracle.com>
	 <20100701180241.GA3594@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Jul 2010 12:28:23 -0700
Message-ID: <1278012503.7738.17.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 20:02 +0200, Andi Kleen wrote:
> > What license (name/type) is this?
> 
> IANAL, but AFAIK standard wisdom is that "disclaimer in the documentation
> and/or other materials provided" is generally not acceptable for Linux
> because it's an excessive burden for all distributors.

It's the BSD license ..

> Also for me it's still quite unclear why we would want this code at all...
> It doesn't seem to do anything you couldn't do with the existing interfaces.

I don't know all that much about what Zach's done here, but from what
he's said so far it looks like this help to manage lots of IOMMUs on a
single system.. On x86 it seems like there's not all that many IOMMUs in
comparison .. Zach mentioned 10 to 100 IOMMUs ..

Daniel

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

