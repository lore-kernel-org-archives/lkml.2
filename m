Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab2HUOxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 10:53:01 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62772 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab2HUOw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 10:52:59 -0400
Date: Tue, 21 Aug 2012 10:42:57 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, joro@8bytes.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 17/19] x86, msi: Introduce x86_msi.compose_msi_msg
 call-back
Message-ID: <20120821144256.GC20097@phenom.dumpdata.com>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-18-git-send-email-joerg.roedel@amd.com>
 <20120820140843.GA7732@phenom.dumpdata.com>
 <20120821084007.GL2582@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821084007.GL2582@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 10:40:07AM +0200, Joerg Roedel wrote:
> On Mon, Aug 20, 2012 at 10:08:44AM -0400, Konrad Rzeszutek Wilk wrote:
> > On Mon, Aug 20, 2012 at 03:56:03PM +0200, Joerg Roedel wrote:
> > > This call-back points to the right function for initializing
> > > the msi_msg structure.
> > 
> > What is the 'hpet_id' purpose in this?
> 
> The VT-d implementation uses it. This function is used to create the MSI
> message for PCI devices and the HPET. When it is called for the HPET the
> pdev parameter is NULL and hpet_id is valid.

Perhaps then a more generic term? 'void *platform_priv' ?
