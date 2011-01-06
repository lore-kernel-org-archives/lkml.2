Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab1AFR5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 12:57:34 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:52637 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355Ab1AFR5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 12:57:32 -0500
Message-ID: <4D260288.8070406@ti.com>
Date: Thu, 06 Jan 2011 11:57:28 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Koen Kooi <koen@dominion.thruhere.net>
CC: Brad Parker <brad@heeltoe.com>, Anand Gadiyar <gadiyar@ti.com>,
        Ming Lei <tom.leiming@gmail.com>, Benoit Cousson <b-cousson@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Walmsley <paul@pwsan.com>, Greg KH <greg@kroah.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org
Subject: Re: linux-next: manual merge of the usb tree with the omap tree
References: <20101223171859.f6842045.sfr@canb.auug.org.au><4D139517.3010608@ti.com> <AANLkTi=pTNg2iWN+=uEv=CyZHHCoddF51pmmCMjPeMUF@mail.gmail.com> <4ce0f816f951f24ca3de9c84d9f70842@mail.gmail.com> (sfid-20110106_100805_509520_6CE1697E) <4D25E313.4060202@heeltoe.com> <8B3471BB-CB3F-4CE6-B523-D9C5E87B9CEC@dominion.thruhere.net>
In-Reply-To: <8B3471BB-CB3F-4CE6-B523-D9C5E87B9CEC@dominion.thruhere.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Koen Kooi had written, on 01/06/2011 10:59 AM, the following:
> Op 6 jan 2011, om 16:43 heeft Brad Parker het volgende geschreven:
> 
>> It's probably expected, but I can't get the EHCI USB port  to work
>> on a beagle board XM (36xx) using the current omap tree.
>>
>> It this most likely due to these clock issues?
> 
> You need this patch: http://thread.gmane.org/gmane.linux.ports.arm.omap/47807/
> 
> I'm currently too lazy to split it up like Nishant wants as I don't see the point splitting for the sake of splitting.--
Alrite, if it is ok with you and Tony, I will help post the split up - 
this will help multiple things:
a) prevents the patch being held off because of multiline comments and 
the link
b) git bisect can isolate to a specific change.
c) A patch should do a single logical thing for helping (b).

-- 
Regards,
Nishanth Menon
