Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab1ANDgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:36:00 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11900 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab1ANDfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:35:55 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6225"; a="70404621"
Message-ID: <4D2FC49A.1000505@codeaurora.org>
Date: Thu, 13 Jan 2011 19:35:54 -0800
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dima Zavin <dima@android.com>
CC: Daniel Walker <dwalker@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: msm: 7x30: don't force a gpiomux table for the whole
 arch
References: <1294680810.12298.2.camel@c-dwalke-linux.qualcomm.com> <1294686030-9817-1-git-send-email-dima@android.com>
In-Reply-To: <1294686030-9817-1-git-send-email-dima@android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/10/2011 11:00 AM, Dima Zavin wrote:
> This is completely board specific and therefore must be provided
> on a per-board basis.
>
> Change-Id: I96f922ad9bb9cbce7874c5ae6ac0d7479b7a2124
> Signed-off-by: Dima Zavin<dima@android.com>
>
Tested-by: Rohit Vaswani <rvaswani@codeaurora.org>

Thanks,
Rohit Vaswani

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

