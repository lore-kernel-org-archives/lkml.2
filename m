Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab0GBHJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 03:09:07 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36317 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719Ab0GBHJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:09:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6030"; a="46114766"
Message-ID: <4C2D908E.9030309@codeaurora.org>
Date: Fri, 02 Jul 2010 00:09:02 -0700
From: Zach Pfeffer <zpfeffer@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Hari Kanigeri <hari.kanigeri@gmail.com>
CC: Daniel Walker <dwalker@codeaurora.org>, Andi Kleen <andi@firstfloor.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, mel@csn.ul.ie,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
References: <1277877350-2147-1-git-send-email-zpfeffer@codeaurora.org> <1277877350-2147-3-git-send-email-zpfeffer@codeaurora.org> <20100701101746.3810cc3b.randy.dunlap@oracle.com> <20100701180241.GA3594@basil.fritz.box> <1278012503.7738.17.camel@c-dwalke-linux.qualc <AANLkTinABCSdN6hnXVOvVZ12f1QBMR_UAi62qW8GmlkL@mail.gmail.com>
In-Reply-To: <AANLkTinABCSdN6hnXVOvVZ12f1QBMR_UAi62qW8GmlkL@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hari Kanigeri wrote:
>> He demonstrated the usage of his code in one of the emails he sent out
>> initially. Did you go over that, and what (or how many) step would you
>> use with the current code to do the same thing?
> 
> -- So is this patch set adding layers and abstractions to help the User ?
> 
> If the idea is to share some memory across multiple devices, I guess
> you can achieve the same by calling the map function provided by iommu
> module and sharing the mapped address to the 10's or 100's of devices
> to access the buffers. You would only need a dedicated virtual pool
> per IOMMU device to manage its virtual memory allocations.

Yeah, you can do that. My idea is to get away from explicit addressing
and encapsulate the "device address to physical address" link into a
mapping.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
