Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab0HZVAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 17:00:34 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2878 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab0HZVAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 17:00:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6086"; a="52238172"
Message-ID: <4C76D5EE.7000805@codeaurora.org>
Date: Thu, 26 Aug 2010 17:00:30 -0400
From: Neil Leeder <nleeder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Stepan Moskovchenko <stepanm@codeaurora.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Horace Fu <horace.fu@quantatw.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Trilok Soni <tsoni@codeaurora.org>
Subject: Re: [PATCH v2] input: mouse: add qci touchpad driver
References: <1281631760-15589-1-git-send-email-nleeder@codeaurora.org> <20100813024912.GA2661@core.coreip.homeip.net> <4C65BF99.9030601@codeaurora.org> <201008131754.49488.dmitry.torokhov@gmail.com> <4C6AC393.8000109@codeaurora.org> <BC741E3E-377E-45BF-80E1-A60F4E0FDFC9@gmail.com> <4C6C52DE.4040700@codeaurora.org> <20100819053311.GE5832@core.coreip.homeip.net> <4C6DADDE.7030107@codeaurora.org> <4C756049.2090408@codeaurora.org> <20100826144937.GA8553@core.coreip.homeip.net>
In-Reply-To: <20100826144937.GA8553@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/2010 10:49 AM, Dmitry Torokhov wrote:
>
> I concur that since EC firmware does not seem to support full PS/2
> protocol we should got with the original driver creating an input device
> rather than serio.
>
> Please send me the latest version of your driver and I will apply it to
> my .37 queue.

Thanks - I'll incorporate review comments and post an updated patch.

--
Neil
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
