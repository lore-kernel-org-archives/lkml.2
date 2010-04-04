Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab0DDLzQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 07:55:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:57352 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab0DDLzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 07:55:12 -0400
Subject: Re: [PATCH 3/4] Revert "x86: disable IOMMUs on kernel crash"
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: Chris Wright <chrisw@sous-sol.org>, nhorman@redhat.com,
       nhorman@tuxdriver.com, Joerg Roedel <joerg.roedel@amd.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       hbabu@us.ibm.com, iommu@lists.linux-foundation.org,
       ebiederm@xmission.com, vgoyal@redhat.com
In-Reply-To: <20100403174128.GQ24846@8bytes.org>
References: <20100403012751.834020949@sous-sol.org>
	 <20100403012820.229410717@sous-sol.org> <20100403174128.GQ24846@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 04 Apr 2010 12:54:46 +0100
Message-ID: <1270382086.21446.3429.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-04-03 at 19:41 +0200, Joerg Roedel wrote:
> Another problem: This also breaks if the kdump kernel has no
> iommu-support. 

The kdump kernel has to support the hardware it's running on.
Film at 11.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

