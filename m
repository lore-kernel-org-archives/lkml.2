Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab1HQBys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 21:54:48 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9684 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab1HQByp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 21:54:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6440"; a="110637442"
Message-ID: <cf66eafcc04bf565edcb330f66a3e12a.squirrel@www.codeaurora.org>
In-Reply-To: <20110817005954.GB27099@opensource.wolfsonmicro.com>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
    <4E4AA52E.1070706@codeaurora.org>
    <0446c62c2d4a2c60442c582b4f61f5d3.squirrel@www.codeaurora.org>
    <4380004.YTvKt3Mlxd@wuerfel> <4E4AFCC9.7020109@codeaurora.org>
    <20110817005954.GB27099@opensource.wolfsonmicro.com>
Date: Tue, 16 Aug 2011 18:54:45 -0700 (PDT)
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
From: "Sagar Dharia" <sdharia@codeaurora.org>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Cc: "Kenneth Heitke" <kheitke@codeaurora.org>, "Arnd Bergmann" <arnd@arndb.de>,
        sdharia@codeaurora.org, "David Brown" <davidb@codeaurora.org>,
        bryanh@codeaurora.org, linux-arm-msm@vger.kernel.org,
        rdunlap@xenotime.net, rmk+kernel@arm.linux.org.uk,
        john.stultz@linaro.org, akpm@linux-foundation.org, ohad@wizery.com,
        gregkh@suse.de, stefanr@s5r6.in-berlin.de, lethal@linux-sh.org,
        linville@tuxdriver.com, zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: sdharia@codeaurora.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Tue, Aug 16, 2011 at 05:27:05PM -0600, Kenneth Heitke wrote:
>
>> For the proposed implementation, the client drivers are probed
>> before their devices are discovered because the client driver may
>> need to power-up the device or pull it out of reset.  Once the
>> device is powered up, the call to get_logical_address() will let the
>> client know whether or not their device has enumerated.
>
> There's a callback generated to left the client know when this has
> happened I'd expect?

As of now, there is no callback to notify them. They can either query it
during 1st transaction, or retry with some delay in the probe itself.
Callback is a good idea and we can definitely use it to inform clients
that their device has come up.

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

