Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab0GJPcF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 11:32:05 -0400
Received: from 8bytes.org ([88.198.83.132]:43222 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487Ab0GJPcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 11:32:03 -0400
Date: Sat, 10 Jul 2010 17:31:59 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Tom Lyon <pugs@cisco.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, chrisw@sous-sol.org, mst@redhat.com,
       dwmw2@infradead.org, joerg.roedel@amd.com, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH V3] 2.6.34: simple IOMMU API extension to check safe
	interrupt remapping
Message-ID: <20100710153159.GE10080@8bytes.org>
References: <4c2e526e.HXT+zIj7fSMwTdy/%pugs@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c2e526e.HXT+zIj7fSMwTdy/%pugs@cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 01:56:14PM -0700, Tom Lyon wrote:
> This patch allows IOMMU users to determine whether the hardware and software
> support safe, isolated interrupt remapping.  Not all Intel IOMMUs have the
> hardware, and the software for AMD is not there yet.
> 	Signed-off-by: Tom Lyon <pugs@cisco.com>
> ---
> Version 3: shorter name requested by Joerg.
> Version 2: previous ifdefs not needed.

Thanks. I apply it when I am back in office (aroun July 19th).

