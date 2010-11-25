Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab0KYVre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 16:47:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60928 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752311Ab0KYVrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 16:47:32 -0500
Date: Thu, 25 Nov 2010 21:47:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        vbarinov@embeddedalley.com, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: tlv320aic3x - fix variable may be used
 uninitialized warning
Message-ID: <20101125214741.GB26792@opensource.wolfsonmicro.com>
References: <1290609659.2749.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290609659.2749.2.camel@phoenix>
X-Cookie: Bridge ahead.  Pay troll.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 10:40:59PM +0800, Axel Lin wrote:
> If aic3x_read failed , val is used uninitialized.
> Fix it by initializing val to 0.

I applied this one too after Liam's ack (via IM), thanks.
