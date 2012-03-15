Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031919Ab2COQul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:50:41 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:50333 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031783Ab2COQuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:50:39 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, ludovic.desroches@atmel.com,
        mpm@selenic.com, herbert@gondor.hengli.com.au, vinod.koul@intel.com,
        a.zummo@towertech.it
Subject: Re: [PATCH 0/6] AT91 drivers Kconfig cleanup
Date: Thu, 15 Mar 2012 09:50:31 -0700
Message-ID: <7104123.IANagkT9hm@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.7.4 (Linux/3.2.9-1.fc16.x86_64; KDE/4.7.4; x86_64; ; )
In-Reply-To: <cover.1331826095.git.nicolas.ferre@atmel.com>
References: <cover.1331826095.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 15, 2012 04:57:16 PM Nicolas Ferre wrote:
> This is a series which deals with AT91 drivers Kconfig entries. Its goal is
> to remove too restrictive dependencies on SoC names.
> This will allow to add support for newer SoC seamlessly.
> 
> One question remains: should I submit those patches through dedicated
> sub-maintainer's git trees or can I queue the whole series in arm-soc?

I'm fine if you queue input piece through arm-soc.

Thanks.

-- 
Dmitry
