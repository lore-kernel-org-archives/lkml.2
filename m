Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab1AYXVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 18:21:34 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23514 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab1AYXVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 18:21:32 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6237"; a="71754604"
From: David Brown <davidb@codeaurora.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stanislaw Gruszka <stf_xl@wp.pl>,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 20/32] video/msm_fb: use system_wq instead of dedicated workqueues
In-Reply-To: <1294062595-30097-21-git-send-email-tj@kernel.org> (Tejun Heo's
	message of "Mon, 3 Jan 2011 14:49:43 +0100")
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
	<1294062595-30097-21-git-send-email-tj@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110125:linux-arm-msm@vger.kernel.org::Xya332UvNVusaa12:000000000000000000000000000000004HOi
X-Hashcash: 1:20:110125:tj@kernel.org::uf8Ui6yW4MPw3GSX:00000cc8
X-Hashcash: 1:20:110125:linux-usb@vger.kernel.org::MCBn6VztrJrS20E5:0000000000000000000000000000000000002ehZ
X-Hashcash: 1:20:110125:linux-kernel@vger.kernel.org::hZ7xsc2xpu6ymPxY:0000000000000000000000000000000005kxF
X-Hashcash: 1:20:110125:stf_xl@wp.pl::KXNK07HDGGwsM9sO:000007vVc
Date: Tue, 25 Jan 2011 15:21:31 -0800
Message-ID: <8yaoc74d0xw.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03 2011, Tejun Heo wrote:

> With cmwq, there's no reason to use separate workqueues.  Drop
> msmfb_info->resume_workqueue and use system_wq instead.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Stanislaw Gruszka <stf_xl@wp.pl>
> Cc: linux-usb@vger.kernel.org
> ---
> Only compile tested.  Please feel free to take it into the subsystem
> tree or simply ack - I'll route it through the wq tree.

I'll pull this into the MSM tree.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
