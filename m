Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab1EULI3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 07:08:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50649 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab1EULI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 07:08:27 -0400
Subject: Re: [PATCH v1 RESEND] audio: tlv320aic26: fix PLL register
 configuration
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Michael Williamson <michael.williamson@criticallink.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com, tiwai@suse.de
In-Reply-To: <1305901566-8125-1-git-send-email-michael.williamson@criticallink.com>
References: <1305901566-8125-1-git-send-email-michael.williamson@criticallink.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 May 2011 12:08:22 +0100
Message-ID: <1305976102.3317.2.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 10:26 -0400, Michael Williamson wrote:
> The current PLL configuration code for the tlc320aic26 codec appears to assume a
> hardcoded system clock of 12 MHz.  Use the clock value provided by the DAI_OPS
> API for the calculation.
> 
> Tested using a MityDSP-L138 platform providing a 24.576 MHz clock.
> 
> Signed-off-by: Michael Williamson <michael.williamson@criticallink.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> This got bounced by the alsa-devel list (I wasn't on list).  I'm not sure 
> whose tree this needs to go through, but given the lack of response
> I'm guessing alsa-devel. If I'm missing a list, any advice would be 
> appreciated.

Applied.

Thanks

Liam

