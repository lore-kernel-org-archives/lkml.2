Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287Ab0KPDtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 22:49:08 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44237 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab0KPDtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 22:49:06 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6168"; a="62802123"
Message-ID: <4CE1FF2F.6090105@codeaurora.org>
Date: Tue, 16 Nov 2010 09:19:03 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Trilok Soni <tsoni@codeaurora.org>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-arm-msm@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC v1 PATCH 2/6] input: pm8058_keypad: Qualcomm PMIC8058 keypad
 controller driver
References: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org> <1289393281-4459-3-git-send-email-tsoni@codeaurora.org>
In-Reply-To: <1289393281-4459-3-git-send-email-tsoni@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 11/10/2010 6:17 PM, Trilok Soni wrote:
> Add Qualcomm PMIC8058 based keypad controller driver
> supporting upto 18x8 matrix configuration.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Trilok Soni <tsoni@codeaurora.org>
> ---
>  drivers/input/keyboard/Kconfig           |   11 +
>  drivers/input/keyboard/Makefile          |    1 +
>  drivers/input/keyboard/pmic8058-keypad.c |  769 ++++++++++++++++++++++++++++++
>  include/linux/input/pmic8058-keypad.h    |   58 +++
>  4 files changed, 839 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/input/keyboard/pmic8058-keypad.c
>  create mode 100644 include/linux/input/pmic8058-keypad.h

Any comments on this patch?

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
