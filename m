Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab1ARCu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 21:50:27 -0500
Received: from amavis-outgoing2.knology.net ([24.214.64.231]:45563 "EHLO
	amavis-outgoing2.knology.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753385Ab1ARCu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 21:50:26 -0500
Subject: Re: scsi: include linux/scatterlist.h to pick up ARCH_HAS_SG_CHAIN
From: David Dillow <dillowda@ornl.gov>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        James.Bottomley@suse.de
In-Reply-To: <4D340F49.6030604@panasas.com>
References: <1295208759.2574.14.camel@obelisk.thedillows.org>
	 <4D340F49.6030604@panasas.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 21:50:22 -0500
Message-ID: <1295319022.3051.84.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 11:43 +0200, Boaz Harrosh wrote:
> > Another option is to potentially get rid of the ARCH_HAS_SG_CHAIN define
> > as all archs have it save m68knommu.
> 
> What's preventing m68knommu from chaining? this is pure C manipulations,
> what am I missing?

Hopefully someone else will know -- I didn't look very hard once I saw
that it had no arch-specific asm include directory that I could readily
find.

Thanks for taking a look,
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

