Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab1CUHGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 03:06:17 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5829 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab1CUHGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 03:06:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6291"; a="81097095"
Message-ID: <4D86F8E1.8060502@codeaurora.org>
Date: Mon, 21 Mar 2011 12:36:09 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.14) Gecko/20110221 Thunderbird/3.1.8
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, Mohan Pallaka <mpallaka@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/2] input: misc: Add support for isa1200 chip
References: <1299496182-26177-1-git-send-email-mpallaka@codeaurora.org> <1299496182-26177-3-git-send-email-mpallaka@codeaurora.org>
In-Reply-To: <1299496182-26177-3-git-send-email-mpallaka@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 3/7/2011 4:39 PM, Mohan Pallaka wrote:
> From: Kyungmin Park <kyungmin.park@samsung.com>
> 
> isa1200 chip can be used to generate vibrations to indicate
> silent alerts, providing gaming haptic actions or vibrations
> in response to touches. It can operate in two modes, pwm
> generation and pwm input mode. Pwm generation mode requires
> external clock and pwm input mode needs the pwm signal to be
> given as input to the chip.
> 

Could you please review this patch series?

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
