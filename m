Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab0GMFrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 01:47:01 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34383 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab0GMFrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 01:47:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6041"; a="47143742"
Message-ID: <4C3BFDD3.8040209@codeaurora.org>
Date: Mon, 12 Jul 2010 22:46:59 -0700
From: Zach Pfeffer <zpfeffer@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Daniel Walker <dwalker@codeaurora.org>, Andi Kleen <andi@firstfloor.org>,
        Randy Dunlap <randy.dunlap@oracle.com>, mel@csn.ul.ie,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
References: <1277877350-2147-1-git-send-email-zpfeffer@codeaurora.org> <1277877350-2147-3-git-send-email-zpfeffer@codeaurora.org> <20100701101746.3810cc3b.randy.dunlap@oracle.com> <20100701180241.GA3594@basil.fritz.box> <1278021944.7738.43.camel@c-dwalke-linux.qualcomm.com> <4C2D965F.5000206@codeaurora.org> <20100710145639.GC10080@8bytes.org>
In-Reply-To: <20100710145639.GC10080@8bytes.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> On Fri, Jul 02, 2010 at 12:33:51AM -0700, Zach Pfeffer wrote:
>> Daniel Walker wrote:
> 
>>> So if we include this code which "map implementations" could you
>>> collapse into this implementations ? Generally , what currently existing
>>> code can VCMM help to eliminate?
>> In theory, it can eliminate all code the interoperates between IOMMU,
>> CPU and non-IOMMU based devices and all the mapping code, alignment,
>> mapping attribute and special block size support that's been
>> implemented.
> 
> Thats a very abstract statement. Can you point to particular code files
> and give a rough sketch how it could be improved using VCMM?

I can. Not to single out a particular subsystem, but the video4linux
code contains interoperation code to abstract the difference between
sg buffers, vmalloc buffers and physically contiguous buffers. The
VCMM is an attempt to provide a framework where these and all the
other buffer types can be unified.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
