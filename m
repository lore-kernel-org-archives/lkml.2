Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0HTTQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 15:16:58 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43761 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab0HTTQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 15:16:56 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6080"; a="51700537"
Message-ID: <4C6ED4A6.8060208@codeaurora.org>
Date: Fri, 20 Aug 2010 15:16:54 -0400
From: Neil Leeder <nleeder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Horace Fu <horace.fu@quantatw.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Trilok Soni <tsoni@codeaurora.org>
Subject: Re: [PATCH v2] input: mouse: add qci touchpad driver
References: <1281631760-15589-1-git-send-email-nleeder@codeaurora.org> <20100813024912.GA2661@core.coreip.homeip.net> <4C65BF99.9030601@codeaurora.org> <201008131754.49488.dmitry.torokhov@gmail.com> <4C6AC393.8000109@codeaurora.org> <BC741E3E-377E-45BF-80E1-A60F4E0FDFC9@gmail.com> <4C6C52DE.4040700@codeaurora.org> <20100819053311.GE5832@core.coreip.homeip.net> <4C6DADDE.7030107@codeaurora.org> <20100819233532.GB21662@srcf.ucam.org>
In-Reply-To: <20100819233532.GB21662@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/19/2010 7:35 PM, Matthew Garrett wrote:
> By any incredible stroke of luck, does it have a unique PNPID?
> /sys/bus/pnp/devices/*/id should give you some insight.
>

Thanks but I'm running this on an ARM netbook which doesn't have 
/sys/bus/pnp.

--
Neil
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
