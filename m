Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab2GECuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 22:50:55 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14877 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab2GECuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 22:50:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6762"; a="207490291"
Message-ID: <4FF50107.8030406@codeaurora.org>
Date: Wed, 04 Jul 2012 19:50:47 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        =?UTF-8?B?U2p1ciBCcsOmbmRlbA==?= =?UTF-8?B?YW5k?= 
	<sjur.brandeland@stericsson.com>
Subject: Re: [PATCH] remoteproc: adopt the driver core's alloc/add/del/put
 naming
References: <1341409019-32166-1-git-send-email-ohad@wizery.com>
In-Reply-To: <1341409019-32166-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/4/2012 6:36 AM, Ohad Ben-Cohen wrote:
> To make remoteproc's API more intuitive for developers, we adopt
> the driver core's naming, i.e. alloc -> add -> del -> put. We'll also
> add register/unregister when their first user shows up.
>
> Otherwise - there's no functional change here.
>
> Suggested by Russell King <linux@arm.linux.org.uk>.
>
> Cc: Russell King <linux@arm.linux.org.uk>

Acked-by: Stephen Boyd <sboyd@codeaurora.org>

> Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>
> Cc: Sjur Brændeland <sjur.brandeland@stericsson.com>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

