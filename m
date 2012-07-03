Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab2GCSL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 14:11:56 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2005 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab2GCSLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 14:11:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6761"; a="207164191"
Message-ID: <4FF335E3.5040509@codeaurora.org>
Date: Tue, 03 Jul 2012 11:11:47 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?B?U2p1ciBCcsOmbmRlbGFuZA==?= 
	<sjur.brandeland@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Michal Simek <monstr@monstr.eu>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Suman Anna <s-anna@ti.com>, Mark Grosen <mgrosen@ti.com>
Subject: Re: [PATCH] remoteproc: remove the get_by_name/put API
References: <1341259857-17382-1-git-send-email-ohad@wizery.com>
In-Reply-To: <1341259857-17382-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/12 13:10, Ohad Ben-Cohen wrote:
> Remove rproc_get_by_name() and rproc_put(), and the associated
> remoteproc infrastructure that supports it (i.e. klist and friends),
> because:
>
> 1. No one uses them
> 2. Using them is highly discouraged, and any potential user
>    will be deeply scrutinized and encouraged to move.
>
> If a user, that absolutely can't live with the direct boot/shutdown
> model, does show up one day, then bringing this functionality back
> is going to be trivial.
>
> At this point though, keeping this functionality around is way too
> much of a maintenance burden.
>

Acked-by: Stephen Boyd <sboyd@codeaurora.org>

> Cc: Sjur Brændeland <sjur.brandeland@stericsson.com>
> Cc: Loic Pallardy <loic.pallardy@stericsson.com>
> Cc: Ludovic BARRE <ludovic.barre@stericsson.com>
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>
> Cc: Suman Anna <s-anna@ti.com>
> Cc: Mark Grosen <mgrosen@ti.com>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
>
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

