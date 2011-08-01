Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab1HAGOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 02:14:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53492 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753576Ab1HAGOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 02:14:44 -0400
Date: Mon, 1 Aug 2011 15:14:29 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] regulator: tps65023: Setting correct core regulator
 for tps65021
Message-ID: <20110801061427.GA13856@opensource.wolfsonmicro.com>
References: <marcus.folkesson@gmail.com>
 <1311762767-20263-1-git-send-email-marcus.folkesson@gmail.com>
 <1311762767-20263-3-git-send-email-marcus.folkesson@gmail.com>
 <20110729123309.GA22042@sirena.org.uk>
 <4E331124.40601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E331124.40601@gmail.com>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 09:59:32PM +0200, Marcus Folkesson wrote:
> On 07/29/2011 02:33 PM, Mark Brown wrote:
> > On Wed, Jul 27, 2011 at 12:32:46PM +0200, Marcus Folkesson wrote:
> >> TPS65023 is using VDCDC1 as core regulator and TPS65021 is using VDCDC3.
> >> Core-regulator, voltage-tables and size of voltage-table may differ between
> >> different regulators. All those three is now passed as driver data.
> > 
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Changing struct member tps_driver_data.info to const for avoiding awkward type castings.
> 
> Changes from original patch:

This is probably fine but please resubmit the patch normally so it can
be reviewed as a whole.
