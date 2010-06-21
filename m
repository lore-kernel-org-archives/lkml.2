Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab0FUC4j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 22:56:39 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34900 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010Ab0FUC4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 22:56:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=CJUyXj0/5ly5ZtbSQBXV1jm/fnoQvXpEHj0iiy4ScwCZr9Dkn3ZMZCqtBYxdAeXODc
         PeSKgUt7YTjzp8HU2fRX149Xj+vYnzfXYss8LKJ2NSvNR2ODbBgXo18ey0UF0Hvl8X+X
         Q4ExKGSEf5Q0+BmQljDN1qtnK8nmW3fU9+Av8=
Message-ID: <4C1ED4CA.9030906@gmail.com>
Date: Mon, 21 Jun 2010 10:56:10 +0800
From: Xiangfu Liu <xiangfu.z@gmail.com>
Organization: www.openmobilefree.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
CC: Lars-Peter Clausen <lars@metafoo.de>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anton Vorontsov <cbouatmailru@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Samuel Ortiz <sameo@linux.intel.com>, alsa-devel@alsa-project.org,
       linux-fbdev@vger.kernel.org, linux-mmc@vger.kernel.org,
       linux-mtd@lists.infradead.org, linux-usb@vger.kernel.org,
       lm-sensors@lm-sensors.org, rtc-linux@googlegroups.com
Subject: Re: [PATCH v2 00/26] Add support for the Ingenic JZ4740 System-on-a-Chip
References: <1276924111-11158-1-git-send-email-lars@metafoo.de> <20100620092610.GA4950@alpha.franken.de>
In-Reply-To: <20100620092610.GA4950@alpha.franken.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2010 05:26 PM, Thomas Bogendoerfer wrote:
> great stuff. I have a JZ4730 based netbook, for which I started magling
> the provided sources quite some time ago, but I didn't reach the
> point of submitting patches... there are a lot of common stuff between
> JZ4730 and JZ4740 so IMHO it would be a good thing not to nail
> everthing to JZ4740 namewise. It might also a good idea to select
> something like arch/mips/jzrisc as base directory, put the

Hi Thomas

I would advice "xburst" instead jzrisc. because the Ingenic call
their cpu "XBurst" series. like: XBurst JZ4740, XBurst JZ4750 ...


> factored out code there and add JZ4730/JZ4740 in either seperate
> files or directories.


-- 
Best Regards
Xiangfu Liu
http://www.openmobilefree.net
