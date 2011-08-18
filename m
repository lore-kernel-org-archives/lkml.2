Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab1HRNz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 09:55:28 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:61959 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750731Ab1HRNz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 09:55:27 -0400
Message-ID: <4E4D1931.2070303@metafoo.de>
Date: Thu, 18 Aug 2011 15:52:49 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 4/4] Blackfin: bf537: Stamp: Register ASoC EVAL-ADAU1373
 board driver
References: <1313432124-22591-1-git-send-email-lars@metafoo.de> <1313432124-22591-4-git-send-email-lars@metafoo.de> <20110816155606.GG15484@opensource.wolfsonmicro.com>
In-Reply-To: <20110816155606.GG15484@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2011 05:56 PM, Mark Brown wrote:
> On Mon, Aug 15, 2011 at 08:15:24PM +0200, Lars-Peter Clausen wrote:
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>> Cc: Mike Frysinger <vapier@gentoo.org>
> 
> I'm OK with this but may as well go via the blackfin tree as there's no
> code dependency on any of the ASoC stuff and it reduces the risk of any
> collisions with other blackfin work.  If you guys would prefer that it
> goes via ASoC then I can apply it there though.

We'll try to let this go through the blackfin tree.

Thanks
- Lars
