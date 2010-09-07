Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab0IGV6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 17:58:01 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56333 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab0IGV57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 17:57:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6098"; a="53550432"
Message-ID: <4C86B567.8030804@codeaurora.org>
Date: Tue, 07 Sep 2010 17:57:59 -0400
From: Neil Leeder <nleeder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Horace Fu <horace.fu@quantatw.com>, Hsin.Wu@quantatw.com,
        mcuos.com@gmail.com
Subject: Re: [PATCH 0/1] input: keyboard: add qci keyboard driver
References: <4C7838DD.1020004@codeaurora.org> <201008271533.01542.dmitry.torokhov@gmail.com> <4C7BF6D2.5080501@codeaurora.org> <20100830215556.GC28865@core.coreip.homeip.net> <4C7D6C17.1070604@codeaurora.org> <20100901063430.GG23585@core.coreip.homeip.net> <4C8148C6.2010006@codeaurora.org> <20100903203717.GA6412@core.coreip.homeip.net>
In-Reply-To: <20100903203717.GA6412@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/2010 4:37 PM, Dmitry Torokhov wrote:
>
> Does this mean you are not interested in getting drivers for the current
> generation of hardware to mainline?

Hi Dmitry,

That's correct - I don't think there is much future for the current 
hardware if we can come up with a cleaner solution for the new versions. 
  I will test 0xF5 with the new hardware.  I think we may still need a 
new keyboard driver, just rewritten to have a serio backend. If so, I 
will incorporate your changes as well as Trilok's review comments. 
Thanks for your reviews and code suggestions.

--
Neil
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
