Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab1AYAJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:09:54 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47543 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1AYAJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:09:52 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6236"; a="71612061"
Subject: Re: [PATCH v2 01/11] msm: Add CPU queries
From: Daniel Walker <dwalker@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1295468747-22796-2-git-send-email-davidb@codeaurora.org>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	 <1295468747-22796-1-git-send-email-davidb@codeaurora.org>
	 <1295468747-22796-2-git-send-email-davidb@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 16:09:23 -0800
Message-ID: <1295914163.29639.77.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 12:25 -0800, David Brown wrote:
> +#define cpu_is_msm7x01()       0
> +#define cpu_is_msm7x30()       0
> +#define cpu_is_qsd8x50()       0
> +#define cpu_is_msm8x60()       0

Now that I look at this again, why not drop the "x" all together ?

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

