Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab1CRIZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 04:25:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53618 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab1CRIZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 04:25:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: andy.green@linaro.org
Subject: Re: RFC: Platform data for onboard USB assets
Date: Fri, 18 Mar 2011 09:25:29 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, Greg KH <greg@kroah.com>,
        devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <20110311165642.GA9996@kroah.com> <20110317232756.GA3148@angua.secretlab.ca> <4D830E97.4010403@linaro.org>
In-Reply-To: <4D830E97.4010403@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103180925.30074.arnd@arndb.de>
X-Provags-ID: V02:K0:4EyjZo2M800P9qd0ytbYnf+piarhMliAZsuNLxzZdY/
 oRqmtYV2YYQS2odxjL2J3bppx5/9A1P+f9ngU9x8iWGpz7S9ce
 yc9wwNdUpJUd3SZVgXCtDSawPU1nVLQENlrx+VICwEoZ9x0b7A
 99ZUC9GyXYVsfzhVU5xNuONFs8xlTlFxYq9rPoTY4WgNhPWfPr
 0GKNt/IerVrXXOrCkBdIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 March 2011, Andy Green wrote:
> On 03/17/2011 11:27 PM, Somebody in the thread at some point said:
> 
> > The patch below also looks right to me.  I believe it also has the
> > advantage of u-boot already knowing how to update the
> > local-mac-address property at boot time.
> 
> In my (tested, working, complete) patch series, I allow platform_data 
> based override of MAC at usbnet level, so all the drivers can benefit 
> from it.
>
> Is this not a case of "small thinking" from a Device Tree perspective 
> that Arnd's patch only targets smsc95xx?  Or did I miss some 
> disadvantage to allowing this functional configuration option at usbnet 
> layer?

I think either way works (usb-net or individual drivers), the difference is 
which information you use when both a hardware MAC address and the
local-mac-address property are used. Your patch uses the local-mac-address,
mine would use the hardware mac address and only fall back to the
property if there is no other one.

I still need to look at your patch series, I didn't realize you had
already sent it.

	Arnd
