Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab0HaQue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 12:50:34 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11656 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab0HaQud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 12:50:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6091"; a="52891754"
Subject: Re: [PATCH 1/2] msm: Install the Google-Android gpio driver.
From: Daniel Walker <dwalker@codeaurora.org>
To: Gregory Bean <gbean@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
In-Reply-To: <1283213906-17671-1-git-send-email-gbean@codeaurora.org>
References: <1283213906-17671-1-git-send-email-gbean@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 09:50:18 -0700
Message-ID: <1283273418.11790.3.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-30 at 17:18 -0700, Gregory Bean wrote:
> +                       /* printk("%s %08x %08x bit %d gpio %d irq %d\n",
> +                               __func__, v, m, j, msm_chip->chip.start + j,
> +                               FIRST_GPIO_IRQ + msm_chip->chip.start + j); */
> 

Can you drop everything that's un-used .. There's also the enter/exit
sleep functions, which I'm pretty sure aren't used. Also break this into
two patches one for gpio and another for the interrupt component ..

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

