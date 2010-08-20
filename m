Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab0HTPc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 11:32:57 -0400
Received: from slowhand.arndnet.de ([88.198.19.76]:50405 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752863Ab0HTPcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 11:32:55 -0400
Message-ID: <4C6E9A0A.6060205@arndnet.de>
Date: Fri, 20 Aug 2010 17:06:50 +0200
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Lightning/1.0b1 Thunderbird/3.0.6
MIME-Version: 1.0
To: Yusuke Goda <yusuke.goda.sx@renesas.com>
CC: ian@mnementh.co.uk, damm@opensource.se, sameo@linux.intel.com,
        Paul Mundt <lethal@linux-sh.org>, g.liakhovetski@gmx.de,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tmio_mmc: Allow 2 byte requests in 4-bit mode
References: <4C4555DA.40203@renesas.com>
In-Reply-To: <4C4555DA.40203@renesas.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 20.07.2010 09:52, schrieb Yusuke Goda:
> Adjust the tmio_mmc block size check to accept 2-byte requests in
> 4-bit mode. Tested with the SDHI hardware block included in sh7724.
>
> Signed-off-by: Yusuke Goda <yusuke.goda.sx@renesas.com>

Tested on AP4EVB (sh7372) with SDHC and MMC cards - no regression.

Tested-by: Arnd Hannemann <arnd@arndnet.de>
