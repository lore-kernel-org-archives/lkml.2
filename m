Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1AJOJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 09:09:33 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:41734 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753765Ab1AJOJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 09:09:32 -0500
Message-ID: <4D2B1314.3010901@ti.com>
Date: Mon, 10 Jan 2011 19:39:24 +0530
From: Anand Gadiyar <gadiyar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Benoit Cousson <b-cousson@ti.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Walmsley <paul@pwsan.com>, Greg KH <greg@kroah.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org
Subject: Re: linux-next: manual merge of the usb tree with the omap tree
References: <20101223171859.f6842045.sfr@canb.auug.org.au>	<4D139517.3010608@ti.com>	<AANLkTi=pTNg2iWN+=uEv=CyZHHCoddF51pmmCMjPeMUF@mail.gmail.com>	<4ce0f816f951f24ca3de9c84d9f70842@mail.gmail.com>	<AANLkTimA5UOVn6+xe0ofV1F3_XhAP0daBvOAX2k1u_dU@mail.gmail.com>	<AANLkTimzQ1PHN986fqPF0yjd1M+390nSUDYJ65pu0z_f@mail.gmail.com>	<4D271E0E.8050401@ti.com>	<AANLkTikLQRHyp-TS_idEp5Fr74qC3vDoMqqsAA2v_oV8@mail.gmail.com>	<c822ad4569a9dc865b5ccf39e12c828b@mail.gmail.com>	<f853a77e2aebea4130fc486bdbf4aa06@mail.gmail.com> <AANLkTimakCyo5WB4v677-y+V=EO3nPiMTh+msnxkJiwH@mail.gmail.com>
In-Reply-To: <AANLkTimakCyo5WB4v677-y+V=EO3nPiMTh+msnxkJiwH@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/10/2011 7:23 PM, Ming Lei wrote:
> Hi,
> 
> 2011/1/7 Anand Gadiyar <gadiyar@ti.com>:
> 
>> Update: I disabled CONFIG_OMAP_RESET_CLOCKS and the PHY and other
>> connected devices enumerate just fine. Could you try this out on
>> your board as well?
> 
> Yes, it does work for me if CONFIG_OMAP_RESET_CLOCKS is disabled.
> 
> thanks,

Great, patch coming up in a few minutes.

I figured out why we need auxclk3 - the PHY's reference clock
is provided by it.

- Anand

