Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab1C1SrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:47:21 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41874 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab1C1SrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:47:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6299"; a="82532079"
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [PATCH 1/2] msm: clock: Support dummy clocks
References: <1301009686-4042-1-git-send-email-sboyd@codeaurora.org>
	<1301009686-4042-2-git-send-email-sboyd@codeaurora.org>
Date: Mon, 28 Mar 2011 11:48:14 -0700
In-Reply-To: <1301009686-4042-2-git-send-email-sboyd@codeaurora.org> (Stephen
	Boyd's message of "Thu, 24 Mar 2011 16:34:45 -0700")
Message-ID: <8yamxkfw07l.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24 2011, Stephen Boyd wrote:

> Implement a dummy clock driver and macro in the spirit of
> CLK_PCOM(). This is useful on targets where a pclk doesn't exist
> and we want to keep drivers sane by providing such clocks.
>
> Change-Id: Iad37f6e5f19052127814934cf7484971fdb4fcda

Please remember to remove any 'Change-Id' lines before posting patches.
I'll pull these out of these patches.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
