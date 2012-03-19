Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030203Ab2CSFNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:13:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57525 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964779Ab2CSFNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:13:32 -0400
X-AuditID: cbfee61a-b7b78ae000001ceb-2a-4f66c07a0b86
Message-id: <4F66C07C.8000707@samsung.com>
Date: Mon, 19 Mar 2012 14:13:32 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [RESEND PATCH v2 0/2] MAX77693: add initial MAX77693 MFD driver
References: <4F5EDB00.2040405@samsung.com>
In-reply-to: <4F5EDB00.2040405@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Samuel,

I posted following patchset  last week.
Do you have any comment about this patchset?

Thank you,
Chanwoo Choi

On 03/13/2012 02:28 PM, Chanwoo Choi wrote:
> MAX77693 is sub PMIC(Power Management IC) working with other main PMIC.
> It has several features:
> -PMIC
> -MUIC(Micro USB Interface Controller)
> -Camera flash LED control
> -Haptic motor control
> 
> This patch adds initial basis for several devices.
> ---
> Changes for v2:
>     - with comments from Mark
> 	- use devm_kzalloc rather than kzalloc
> 	- print device ID read from device
> 
> Donggeun Kim (2):
>   MFD: MAX77693: add MAX77693 MFD driver
>   MFD: MAX77693: add IRQ handler
> 
>  drivers/mfd/Kconfig                  |   12 ++
>  drivers/mfd/Makefile                 |    1 +
>  drivers/mfd/max77693-irq.c           |  307
> ++++++++++++++++++++++++++++++++++
>  drivers/mfd/max77693.c               |  256 ++++++++++++++++++++++++++++
>  include/linux/mfd/max77693-private.h |  221 ++++++++++++++++++++++++
>  include/linux/mfd/max77693.h         |   38 ++++
>  6 files changed, 835 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/max77693-irq.c
>  create mode 100644 drivers/mfd/max77693.c
>  create mode 100644 include/linux/mfd/max77693-private.h
>  create mode 100644 include/linux/mfd/max77693.h

