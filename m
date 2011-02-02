Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab1BBHv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 02:51:58 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63647 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1BBHv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 02:51:57 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6244"; a="72886651"
Message-ID: <4D490D16.3030601@codeaurora.org>
Date: Wed, 02 Feb 2011 13:21:50 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Anirudh Ghayal <aghayal@codeaurora.org>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [rtc-linux] [RFC v2 PATCH 5/7] input: pmic8058-othc: Add	support
 for PM8058 based OTHC
References: <1296568063-12010-1-git-send-email-aghayal@codeaurora.org> <1296568063-12010-6-git-send-email-aghayal@codeaurora.org> <20110201143356.GB20088@sirena.org.uk>
In-Reply-To: <20110201143356.GB20088@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 2/1/2011 8:03 PM, Mark Brown wrote:
> On Tue, Feb 01, 2011 at 07:17:41PM +0530, Anirudh Ghayal wrote:
>> One-touch headset controller is a hardware module in Qualcomm's PMIC8058.
>> It supports headset insert/remove and switch press/release detection events
>> over 3 MIC BIAS lines. The MIC BIAS lines can be configured to support
>> headset detection or act as regular BIAS lines.
> 
> This should probably be integrated with ASoC for management of the
> biases if nothing else, though it'd also allow other stuff.  ALSA has
> support for creating input devices from jacks already.
> 
>> +	input_set_capability(ipd, EV_SW, SW_HEADPHONE_INSERT);
>> +	input_set_capability(ipd, EV_KEY, KEY_MEDIA);
> 
> The ALSA (well, ASoC) stuff would also allow the input device to be
> merged with that for other detection methods so if you've got a headset
> jack capable of detecting other things (eg, mechanical insertion or
> separate mic and headphone detection).

Thanks for the review. We will analyze on how much we should be able to move
from this OTHC driver to ALSA jack detection.

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
