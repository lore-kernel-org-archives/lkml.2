Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1AJOIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 09:08:21 -0500
Received: from gateway.heeltoe.com ([66.134.219.32]:40583 "EHLO
	gateway.heeltoe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab1AJOIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 09:08:19 -0500
X-DKIM: Sendmail DKIM Filter v2.5.4 gateway.heeltoe.com D4217CC05D
Message-ID: <4D2B12D1.5060807@heeltoe.com>
Date: Mon, 10 Jan 2011 09:08:17 -0500
From: Brad Parker <brad@heeltoe.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: balbi@ti.com
CC: bryan.wu@canonical.com, felipe.balbi@nokia.com, linux-usb@vger.kernel.org,
        david-b@pacbell.net, kernel-team@lists.ubuntu.com,
        linux-kernel@vger.kernel.org, ricardo.salveti@canonical.com,
        linux-omap@vger.kernel.org
Subject: Re: UNS: Re: [PATCH] musb: move usb_add_hcd to the core init code
 from gadget code (v2)
References: <1279895783-7313-1-git-send-email-bryan.wu@canonical.com> <4C600171.5020405@canonical.com> <4D2AF1EE.8010105@heeltoe.com> <20110110115714.GA5573@legolas.emea.dhcp.ti.com> (sfid-20110110_070231_150867_75CADAA4)
In-Reply-To: <20110110115714.GA5573@legolas.emea.dhcp.ti.com> (sfid-20110110_070231_150867_75CADAA4)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi wrote:
> Hi,
>
> On Mon, Jan 10, 2011 at 06:47:58AM -0500, Brad Parker wrote:
>   
>> ...
>> (my expectation is that the mode should toggle from "b_idle" to "a_host"
>> when I plug in an a connector with the id pin tied correctly, and
>> back to "b_idle"
>> when I disconnect)
>>     
> What's the problem in simply insmoding a gadget driver ? If you have OTG
> enabled, you _need_ a gadget driver to have a fully working setup. If
> you want host only, then change Kconfig
I guess there are multiple "modalities".

- some users don't use a gadget driver and expect host mode to work 
(they fail)
- some users use a gadget driver and host mode (apparently that works)
- some users use a gadget driver only (they work)

I'd  like to avoid having multiple kernels.  (and to be honest, I'm not 
convinced
just convince I can get the right behaviors by changing the .config; I 
assume
you mean .config and not Kconfig...  I don't think it works but I'll try 
it out)

-brad

