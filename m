Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab1CJMWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 07:22:48 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50649 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1CJMWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 07:22:46 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6280"; a="78928476"
Message-ID: <4D78C2CF.1030708@codeaurora.org>
Date: Thu, 10 Mar 2011 17:53:43 +0530
From: Mohan Pallaka <mpallaka@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mohan Pallaka <mpallaka@codeaurora.org>
CC: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Support for isa1200 haptic chip
References: <1299496182-26177-1-git-send-email-mpallaka@codeaurora.org>
In-Reply-To: <1299496182-26177-1-git-send-email-mpallaka@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/2011 4:39 PM, Mohan Pallaka wrote:
> This patchset includes a __weak attributed pwm apis in pwm.h and
> a ff-memless based isa1200 driver.
> 
> ISA1200 chip can operate in two modes and if the chip has been
> configured for pwm-generation mode, which doesn't use pwm standard
> apis then it'd encounter compilation errors if the host doesn't
> support PWM. This driver is based on Park's isa1200 driver that uses
> haptic class.
> 
> Kyungmin Park (1):
>   input: misc: Add support for isa1200 chip
> 
> Mohan Pallaka (1):
>   pwm: Add __weak attributed functions for pwm operations
> 
>  drivers/input/misc/Kconfig    |   12 ++
>  drivers/input/misc/Makefile   |    1 +
>  drivers/input/misc/isa1200.c  |  440 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/input/isa1200.h |   45 +++++
>  include/linux/pwm.h           |   21 ++-
>  5 files changed, 514 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/input/misc/isa1200.c
>  create mode 100644 include/linux/input/isa1200.h
> 

Ping.

Dmitry, could you spend sometime to review this.

Thanks,
Mohan.

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
