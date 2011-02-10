Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab1BJTCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 14:02:25 -0500
Received: from kroah.org ([198.145.64.141]:55762 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab1BJTCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 14:02:24 -0500
Date: Thu, 10 Feb 2011 10:56:37 -0800
From: Greg KH <greg@kroah.com>
To: Borislav Petkov <bp@amd64.org>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 00/30] amd64_edac: Add Bulldozer support
Message-ID: <20110210185637.GA16128@kroah.com>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 06:15:03PM +0100, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Hi all,
> 
> the following patchset that adds support for our upcoming F15h CPUs.
> Besides adding a new family support, it cleans up a lot in the driver
> and the diffstat says it all:
> 
>  arch/x86/kernel/amd_nb.c      |    2 +-
>  drivers/edac/amd64_edac.c     | 1412 +++++++++++++++++++----------------------
>  drivers/edac/amd64_edac.h     |  357 ++++-------
>  drivers/edac/amd64_edac_inj.c |    8 +-
>  drivers/edac/edac_mc_sysfs.c  |   26 +-
>  drivers/edac/mce_amd.c        |    8 +-
>  drivers/edac/mce_amd.h        |   28 +-
>  include/linux/pci_ids.h       |    2 +-
>  8 files changed, 825 insertions(+), 1018 deletions(-)
> 
> @Greg/@Ingo: Guys, let me know if patch 27/30 should be rerouted over
> your trees or would you rather like to ACK it?

I don't need to ack it or take it as it doesn't pertain to any of the
files I maintain :)

greg k-h
