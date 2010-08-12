Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735Ab0HLOaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 10:30:46 -0400
Received: from 8bytes.org ([88.198.83.132]:50538 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933703Ab0HLOam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 10:30:42 -0400
Date: Thu, 12 Aug 2010 16:30:40 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: dwalker@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v4] arm: msm: Add MSM IOMMU support.
Message-ID: <20100812143040.GX23755@8bytes.org>
References: <1281469529-23340-1-git-send-email-stepanm@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281469529-23340-1-git-send-email-stepanm@codeaurora.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stepan,

On Tue, Aug 10, 2010 at 12:45:29PM -0700, Stepan Moskovchenko wrote:
> Add support for the IOMMUs found on the upcoming Qualcomm
> MSM8x60 chips. These IOMMUs allow virtualization of the
> address space used by most of the multimedia cores on these
> chips. The driver implements the kernel's IOMMU API.

Using the IOMMU-API seems to work out well for this at the first glance.
I will give your patch a more deep review next week when I am back in
office. I really appreciate that your work fits into the IOMMU-API now.

So long,

   Joerg

