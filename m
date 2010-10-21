Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413Ab0JUOGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:06:46 -0400
Received: from smtp.nokia.com ([147.243.1.47]:19518 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758204Ab0JUOGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:06:44 -0400
Message-ID: <4CC0493F.1000701@nokia.com>
Date: Thu, 21 Oct 2010 17:07:59 +0300
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: ext Felipe Contreras <felipe.contreras@gmail.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>	<1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>	<4CBD9FD5.506@nokia.com>	<AANLkTinRRyrXzqEu=u+CCYkmSNGm03SSo1tVG=5_wdpo@mail.gmail.com>	<4CBE9E69.6060803@nokia.com>	<AANLkTinOYDBMVZ3ibG3Md7jdOuOC6NkGWaugvHwT6uqF@mail.gmail.com>	<4CBEB312.7060400@nokia.com>	<AANLkTikom=eRFqCJmYE+k1zn5K2MR9s8HhNXtjOvUqvr@mail.gmail.com>	<4CBEE186.8090701@nokia.com> <AANLkTinULxyUg_vHjk9RsQm4Row7vRC9ApzYXt7ZMQJD@mail.gmail.com>
In-Reply-To: <AANLkTinULxyUg_vHjk9RsQm4Row7vRC9ApzYXt7ZMQJD@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/20/2010 05:38 PM, ext Felipe Contreras wrote:
> On Wed, Oct 20, 2010 at 3:33 PM, Roger Quadros<roger.quadros@nokia.com>  wrote:
>> On 10/20/2010 12:23 PM, ext Felipe Contreras wrote:
>>> On Wed, Oct 20, 2010 at 12:14 PM, Roger Quadros<roger.quadros@nokia.com>
>>>   wrote:
>>>> USB_G_NOKIA just needs a USB gadget controller to work. The gadget
>>>> controller used for the board should come from the board's Kconfig which
>>>> will ideally be supplied by the board's vendor.
>>>
>>> Ok, but USB_OMAP is not supposed to work on the N900? (I tried and it
>>> didn't)
>>
>> No it won't work. USB_OMAP was for older OMAP's. MUSB is on OMAP3 and later.
>> But MUSB is not limited to OMAP SoC.
>
> config USB_GADGET_OMAP
>    depends ARCH_OMAP
>
> So how about s/ARCH_OMAP/ARCH_OMAP1/
>
> Then USB_GADGET_MUSB_HDRC would be selected by default on OMAP2+.
>

But I'm not sure that omap_udc is used only for OMAP1 architecture.
Dave/Tony should confirm this.


-- 
regards,
-roger
