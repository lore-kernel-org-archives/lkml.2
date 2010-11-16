Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab0KPAZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 19:25:13 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46305 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab0KPAZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 19:25:12 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6168"; a="62781759"
Subject: Re: [PATCH 14/14] msm: iommu: Miscellaneous code cleanup
From: Daniel Walker <dwalker@codeaurora.org>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1289619000-13167-15-git-send-email-stepanm@codeaurora.org>
References: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
	 <1289619000-13167-15-git-send-email-stepanm@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 16:25:05 -0800
Message-ID: <1289867105.4050.29.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 19:30 -0800, Stepan Moskovchenko wrote:
> Remove some unneeded assignments and messages, restructure
> a failure path in iova_to_phys, and make __flush_iotlb
> return int in preparation for adding IOMMU clock control.
> 

Why restructure the failure path ?

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

