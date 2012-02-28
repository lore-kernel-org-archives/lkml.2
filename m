Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030440Ab2B1XG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 18:06:28 -0500
Received: from sous-sol.org ([216.99.217.87]:43135 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965655Ab2B1XG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 18:06:27 -0500
X-Greylist: delayed 3034 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Feb 2012 18:06:26 EST
Date: Tue, 28 Feb 2012 14:15:15 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ddutile@redhat.com" <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [Intel IOMMU PATCH] Re-evaluate RMRR info for devices removed
 from si domain
Message-ID: <20120228221515.GA27235@sequoia.sous-sol.org>
References: <9774516974AF5F4C8A2C3C69CD3412332034C987@G9W0755.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9774516974AF5F4C8A2C3C69CD3412332034C987@G9W0755.americas.hpqcorp.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mingarelli, Thomas (Thomas.Mingarelli@hp.com) wrote:
> This patch is being submitted to handle the case where a pci device is
> placed into the si domain, when booting in iommu passthrough mode, then
> removed. The RMRR information for such devices need to be re-processed
> to avoid DMA Read errors due to the Present Bit being cleared in the
> device's context entry.

What happens if that device is attached to a VM, then detached and
rebound to a host driver?  I suspect the reserved memory range won't get
mapped properly for that device in that case.

thanks,
-chris
