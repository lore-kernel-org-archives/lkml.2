Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab1HJCRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 22:17:35 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:36613 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361Ab1HJCRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 22:17:33 -0400
X-Sasl-enc: prmPU2abnlTphpnubBUhAf4XQuIQ5NDpLL2bzWbn82wn 1312942652
Date: Tue, 9 Aug 2011 19:17:19 -0700
From: Greg KH <greg@kroah.com>
To: Kolymine <kolymine@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging : winbond : fix coding style issue in
 phy_calibration.c
Message-ID: <20110810021719.GB23748@kroah.com>
References: <Staging-winbond-fix>
 <1312931618-14470-1-git-send-email-kolymine@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312931618-14470-1-git-send-email-kolymine@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 01:13:38AM +0200, Kolymine wrote:
> Thus us a patch to the phy_calibration.c file that fixes up coding style warning found by the checkpatch.pl tool
> 
> Signed-off-by: Vincent Abel-Grimalt <kolymine@gmail.com>
> ---
>  drivers/staging/winbond/phy_calibration.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)

Please use the scripts/get_maintainer.pl tool to determine who to send
patches to, so they don't get lost.

I've picked this one up for now, but please be more careful in the
future.

greg k-h
