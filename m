Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab2KKXv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 18:51:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:19774 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab2KKXv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 18:51:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,759,1344236400"; 
   d="scan'208";a="167016140"
Date: Mon, 12 Nov 2012 00:51:52 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Chris Ball <cjb@laptop.org>
Cc: wwang <wei_wang@realsil.com.cn>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "oakad@yahoo.com" <oakad@yahoo.com>,
        "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v7 0/3] Add modules to support realtek PCIE card reader
Message-ID: <20121111235152.GH27828@sortiz-mobl>
References: <cover.1351481260.git.wei_wang@realsil.com.cn>
 <508F4A88.8010207@realsil.com.cn>
 <87r4o56w1f.fsf@octavius.laptop.org>
 <509D1C25.9040909@realsil.com.cn>
 <87mwyqrdrb.fsf@octavius.laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwyqrdrb.fsf@octavius.laptop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Fri, Nov 09, 2012 at 10:34:48AM -0500, Chris Ball wrote:
> Hi,
> 
> On Fri, Nov 09 2012, wwang wrote:
> > I have noticed that the file rtsx_pci_sdmmc.c in your mmc-next branch
> > is still v6 patch.  In v7 patch, this MMC part has also been modified
> > to comply with my MFD portion.  So please update to this version.
> >
> > And one more question. Samuel have merged all of my patch set in his
> > for-next branch, including the MMC part.  I don't know whether this
> > will conflict with your tree in the next merge.
> >
> > Hi Samuel:
> >
> > Since the whole patch set has been merged in your for-next branch,
> > does it mean that you will help to merge all of the three parts to
> > linus's tree?
> 
> I've removed the patch from my tree to avoid conflicting with Samuel.
> I'm happy to either have the MMC patch go through the MFD tree with:
> 
> Acked-by: Chris Ball <cjb@laptop.org>
> 
> or to merge the MMC side of v7 myself, whichever Samuel prefers.
I'm taking the patch through my tree, thanks for the ACK.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
