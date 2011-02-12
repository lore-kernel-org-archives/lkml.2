Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab1BLJTY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 04:19:24 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47407 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab1BLJTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 04:19:18 -0500
Date: Sat, 12 Feb 2011 02:19:13 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Russ Gorby <russ.gorby@intel.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        "open list:SPI SUBSYSTEM" <spi-devel-general@lists.sourceforge.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/1] Adding intel_mid_ssp_spi driver : 01/27/2011
Message-ID: <20110212091913.GD17755@angua.secretlab.ca>
References: <1296680512-2758-1-git-send-email-russ.gorby@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296680512-2758-1-git-send-email-russ.gorby@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 01:01:51PM -0800, Russ Gorby wrote:
> Hello SPI maintainers,
> I am sending a patch for the (new) intel_mid_ssp_spi driver for
> consideration for inclusion in the Linux Kernel. This is a SPI master
> controller driver that is being used for the intel MID platform (Medfield).
> It uses the on-board Bulverde SSP controller configured for SPI (spibus #3)
> running at 25Mhz.

Hi Russ,

Just for future reference, when you're only sending one patch, please
put your notes into the patch description itself, or immediately after
the --- line.  No need for a cover letter like this one.

Thanks,
g.

