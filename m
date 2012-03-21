Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673Ab2CUQcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:32:22 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44320 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab2CUQcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:32:20 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, ludovic.desroches@atmel.com,
        mpm@selenic.com, herbert@gondor.hengli.com.au, vinod.koul@intel.com,
        a.zummo@towertech.it
Subject: Re: [PATCH 0/6] AT91 drivers Kconfig cleanup
Date: Wed, 21 Mar 2012 09:32:12 -0700
Message-ID: <2721722.1bE9GCKTjd@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.8.1 (Linux/3.2.10-3.fc16.x86_64; KDE/4.8.1; x86_64; ; )
In-Reply-To: <4F69B159.5030101@atmel.com>
References: <cover.1331826095.git.nicolas.ferre@atmel.com> <7104123.IANagkT9hm@dtor-d630.eng.vmware.com> <4F69B159.5030101@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 21, 2012 11:45:45 AM Nicolas Ferre wrote:
> On 03/15/2012 05:50 PM, Dmitry Torokhov :
> > On Thursday, March 15, 2012 04:57:16 PM Nicolas Ferre wrote:
> >> This is a series which deals with AT91 drivers Kconfig entries. Its goal
> >> is
> >> to remove too restrictive dependencies on SoC names.
> >> This will allow to add support for newer SoC seamlessly.
> >> 
> >> One question remains: should I submit those patches through dedicated
> >> sub-maintainer's git trees or can I queue the whole series in arm-soc?
> > 
> > I'm fine if you queue input piece through arm-soc.
> 
> Ok, good: I have "Acknowledgement" by several maintainers: so yes, I
> will send this series via arm-soc.
> 
> Is this means that I can add your "Acked-by"?

Yes, please.

Acked-by: Dmitry Torokhov <dtor@mail.ru>

Thanks.

-- 
Dmitry
