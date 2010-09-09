Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab0IIGCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 02:02:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52210 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0IIGCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 02:02:04 -0400
Date: Thu, 9 Sep 2010 09:01:10 +0300
From: Felipe Balbi <balbi@ti.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: venki kaps <venkiece2005@gmail.com>, "greg@kroah.com" <greg@kroah.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <me@felipebalbi.com>, "Gadiyar, Anand" <gadiyar@ti.com>
Subject: Re: [PATCH] USB: otg: twl4030: fix phy initialization(v1)
Message-ID: <20100909060110.GC9098@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <AANLkTinnHiCodvHrSxiMCAQXAETczRiZ+sDu2aQXSeG0@mail.gmail.com>
 <AANLkTiksb1AudCzs8-TWdXb11T-QcPx1G_qu6eUtJ74C@mail.gmail.com>
 <AANLkTin7eVyosgK4XhuB_yqR2ao=YJGVidHB1x2802cr@mail.gmail.com>
 <AANLkTinrecJXH+uDxtBsskFLpBCz0VSZMtSiWGFW9YCr@mail.gmail.com>
 <AANLkTinkhY-y6Qv6HJnGbggksdEmULgQ9DTOrNmu1tLp@mail.gmail.com>
 <AANLkTikZK=8HCtXDR_2dSBce1E10xNfBtyXGOJqykV83@mail.gmail.com>
 <AANLkTin8bXvPqdkYQq++wf0iCK=ZAfZ2jnqbgL=xj8yq@mail.gmail.com>
 <AANLkTimwMiOfvCpUfeXPSF8zh3t3YsM_8nDZbuWFcKM4@mail.gmail.com>
 <AANLkTimBBRC7-kg_L7FpS1E5i63NPMi08g9rrG=jtWeD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimBBRC7-kg_L7FpS1E5i63NPMi08g9rrG=jtWeD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 08:49:08PM -0500, Ming Lei wrote:
>2010/9/8 venki kaps <venkiece2005@gmail.com>:
>
>>  To resolve the above issue, we have made "PHY power on" in battery
>> adc on function
>>  and "PHY power down" in battery adc off function.
>
>Good news, the temperature is bad value from battery adc if otg phy is power
>down. Maybe you only need to power on otg phy before reading battery adc, then
>power down otg phy after the reading if no usb calbe is connected with musb
>for decreasing power consumption. (I am not familiar with battery adc, just
>for your refrerence)

I think you only need the usb3v1 regulator. And it can even be in sleep
mode, it doens't have to be on. What I would suggest is that usb3v1
never to be turned off, only put in sleep mode.

-- 
balbi
