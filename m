Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab2CVSak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:30:40 -0400
Received: from 8bytes.org ([88.198.83.132]:35528 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab2CVSaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:30:39 -0400
Date: Thu, 22 Mar 2012 19:30:37 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Gerard Snitselaar <dev@snitselaar.org>
Cc: joerg.roedel@amd.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu: amd: fix section mismatch
Message-ID: <20120322183037.GM26973@8bytes.org>
References: <1331923102-28625-1-git-send-email-dev@snitselaar.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331923102-28625-1-git-send-email-dev@snitselaar.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 11:38:22AM -0700, Gerard Snitselaar wrote:
> amd_iommu_enable_interrupts() called in amd_iommu_resume().
> 
> Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>

Applied to x86/amd, thanks Gerard.

