Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab1IZO0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 10:26:10 -0400
Received: from 8bytes.org ([88.198.83.132]:38685 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271Ab1IZO0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 10:26:08 -0400
Date: Mon, 26 Sep 2011 16:26:06 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Support for PRI and PASID capability
Message-ID: <20110926142606.GD15002@8bytes.org>
References: <1316706551-16138-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316706551-16138-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

On Thu, Sep 22, 2011 at 05:49:07PM +0200, Joerg Roedel wrote:
> here is a patch-set that enables support for the PRI and PASID
> capabilities in the Linux PCI core. These capabilities of a PCIe device
> are tightly coupled with ATS, but not with IOV. So these patches start
> by moving the ATS code into its own file: ats.c.
> 
> Support for the other two capabilities is based on that change. Please
> review the patches and let me know of any objections you might have.

Have you had a chance to look at these patches? Please let me know any
questions or objections you might have.

Thanks,

	Joerg

