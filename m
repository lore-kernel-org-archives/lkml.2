Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab1AUDnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 22:43:25 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61764 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab1AUDnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 22:43:23 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6232"; a="71328650"
Message-ID: <4D3900DB.8090401@codeaurora.org>
Date: Thu, 20 Jan 2011 19:43:23 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Ben Dooks <ben-linux@fluff.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
References: <201101111016.42819.jeremy.kerr@canonical.com>	<20110111031552.GJ3760@linux-sh.org>	<201101111211.30172.jeremy.kerr@canonical.com>	<20110111045423.GP3760@linux-sh.org> <4D3863AC.4020209@fluff.org> <20110120185707.GJ6335@n2100.arm.linux.org.uk>
In-Reply-To: <20110120185707.GJ6335@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 10:57 AM, Russell King - ARM Linux wrote:
> On Thu, Jan 20, 2011 at 04:32:44PM +0000, Ben Dooks wrote:
>> I would vote for all clk lookup and reference counting code be made
>> sleep-able and define it as such.
>
> Always has been and probably always will be.
>

clk_enable/disable APIs have refcounting and they certainly aren't 
sleep-able. I'm not sure if that's what Ben meant though.

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
