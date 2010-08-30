Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0H3SWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 14:22:14 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57093 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab0H3SWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 14:22:12 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6090"; a="52623936"
Message-ID: <4C7BF6D2.5080501@codeaurora.org>
Date: Mon, 30 Aug 2010 14:22:10 -0400
From: Neil Leeder <nleeder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Horace Fu <horace.fu@quantatw.com>, Hsin.Wu@quantatw.com
Subject: Re: [PATCH 0/1] input: keyboard: add qci keyboard driver
References: <4C7838DD.1020004@codeaurora.org> <201008271533.01542.dmitry.torokhov@gmail.com>
In-Reply-To: <201008271533.01542.dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/27/2010 6:33 PM, Dmitry Torokhov wrote:
> No, this is crazy... This is a twin-brother of the touchpad driver and
> I really do not understand why chip claiming to have PS/2 interface
> (3 ports if I were to believe the diagram) would not allow us talk to
> the devices...

I didn't provide a key bit of information, sorry. The keyboard is not 
attached to the EC's PS/2 port. It is on a matrix of GPIOs.

I was trying to explain that even though the firmware on the EC uses 
0xF4 written over i2c to initialize it, it doesn't appear to support 
other PS/2 commands directed to the keyboard on the GPIO matrix.

--
Neil
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
