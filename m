Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711Ab0LNQ7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:59:07 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44748 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759623Ab0LNQ7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:59:05 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6196"; a="66580006"
Date: Tue, 14 Dec 2010 08:59:03 -0800
From: David Brown <davidb@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: David Brown <davidb@codeaurora.org>,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Arve =?utf-8?B?SGrvv71ubmV277+9Zw==?= <arve@android.com>
Subject: Re: [PATCH v4 0/5] SMP support for msm
Message-ID: <20101214165902.GA24646@huya.qualcomm.com>
References: <1292302233-16194-1-git-send-email-johlstei@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292302233-16194-1-git-send-email-johlstei@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 08:50:28PM -0800, Jeff Ohlstein wrote:

> This series adds support for SMP on msm targets, and specifically adds
> support for SMP on the msm8x60. This version is rebased on top of
> Russell's SMP and gic patches, and has fixes for hotplug and smp.

Russell, do you want to pick up these patches as well, since they
depend on the other SMP patches in your tree?

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
