Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab3AFJvh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 04:51:37 -0500
Received: from 8bytes.org ([85.214.48.195]:49840 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab3AFJvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 04:51:35 -0500
Date: Sun, 6 Jan 2013 10:51:33 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Sethi Varun-B16395 <B16395@freescale.com>
Cc: "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tabi Timur-B04825 <B04825@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>
Subject: Re: [PATCH 0/4] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
Message-ID: <20130106095133.GE25591@8bytes.org>
References: <1355493114-21776-1-git-send-email-Varun.Sethi@freescale.com>
 <C5ECD7A89D1DC44195F34B25E172658D2F58B0@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D2F58B0@039-SN2MPN1-013.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sun Jan  6 10:51:34 2013
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50e9492622971759439588
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Varun,

On Thu, Jan 03, 2013 at 05:21:09AM +0000, Sethi Varun-B16395 wrote:
> It's been a while since I submitted this patch. I have tried to
> address your comments regarding the subwindow attribute. I would
> really appreciate if I can get some feedback on this patch.

I have some ideas in mind how we can abstract this in the IOMMU-API
(with an extension to the API). I will send a RFC patchset soon to add
these changes and then we can discuss it.


	Joerg


