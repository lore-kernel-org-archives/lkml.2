Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2J3JkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 05:40:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35704 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292Ab2J3JkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 05:40:03 -0400
Message-ID: <508FA060.5010303@ti.com>
Date: Tue, 30 Oct 2012 15:09:44 +0530
From: Afzal Mohammed <x0148406@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Benoit Cousson <b-cousson@ti.com>
CC: <devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm/dts: am33xx rtc node
References: <1350643825-9657-1-git-send-email-afzal@ti.com>
In-Reply-To: <1350643825-9657-1-git-send-email-afzal@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On Friday 19 October 2012 04:20 PM, Afzal Mohammed wrote:
> add am33xx rtc node.
>
> Signed-off-by: Afzal Mohammed<afzal@ti.com>
> ---
>
> Based on v3.7-rc1,
> Dependent on series "rtc: omap dt support (for am33xx)",
> (https://lkml.org/lkml/2012/10/19/163)

The dependent series has been merged on -mm tree
and are now present in linux-next.

v2 of this patch has been sent with modification on subject
to follow new convention and removing interrupt parent.

Regards
Afzal
