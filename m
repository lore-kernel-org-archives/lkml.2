Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab1EWM6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 08:58:53 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59978 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1EWM6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 08:58:52 -0400
Message-ID: <4DDA5A04.7050703@ti.com>
Date: Mon, 23 May 2011 13:58:44 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Balbi, Felipe" <balbi@ti.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux@slimlogic.co.uk" <linux@slimlogic.co.uk>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>
Subject: Re: [PATCH v4 2/2] USB: TWL6025 allow different regulator name
References: <1306095684-7732-1-git-send-email-gg@slimlogic.co.uk> <1306095684-7732-3-git-send-email-gg@slimlogic.co.uk> <20110522225103.GB15882@opensource.wolfsonmicro.com> <4DDA2FC3.20009@ti.com> <20110523111326.GD5663@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110523111326.GD5663@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/11 12:13, Balbi, Felipe wrote:
> Hi,
> 
> On Mon, May 23, 2011 at 10:58:27AM +0100, Liam Girdwood wrote:
>> On 22/05/11 23:51, Mark Brown wrote:
>>> On Sun, May 22, 2011 at 09:21:24PM +0100, Graeme Gregory wrote:
>>>> The twl6025 uses a different regulator for USB than the 6030 so select
>>>> the correct regulator name depending on the subclass of device.
>>>
>>> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>>
>> Acked-by: Liam Girdwood <lrg@ti.com>
> 
> Maybe it's better for you to carry this one Liam. I'm done taking
> patches for this merge window and this is related to the same series
> adding support to twl6025. Either that or this will be pending until
> 2.6.41 merge window.
> 

Ok, I've now applied it to regulator.

Thanks !

Liam
