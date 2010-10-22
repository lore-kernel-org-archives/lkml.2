Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab0JVPaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 11:30:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52839 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755991Ab0JVPav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 11:30:51 -0400
Date: Fri, 22 Oct 2010 08:30:07 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>,
        Rajendra Nayak <rnayak@ti.com>
Subject: Re: [PATCH] regulator: twl-regulator - fix twlreg_set_mode
Message-ID: <20101022153006.GB16521@opensource.wolfsonmicro.com>
References: <1287736702.2996.4.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287736702.2996.4.camel@mola>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 04:38:22PM +0800, Axel Lin wrote:
> The Singular Message is 16 bits:
>         DEV_GRP[15:13] MT[12]  RES_ID[11:4]  RES_STATE[3:0]
> 
> Current implementation return immedially after sucessfuly write MSB part.
> To properly set mode, we need to write the complete message ( MSB and LSB ).
> 
> In twl.h, now we have defines for PM Master module register offsets,
> use it instead of hard coded 0x15/0x16.
> 
> Use "message & 0xff" to ensure we send correct value for LSB.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> I don't have this hardware handy, I appreciate if someone who has the
> hardware can test this patch.

I beleive Liam has appropriate hardware.
