Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab0G0Wnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 18:43:49 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54208 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab0G0Wnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 18:43:47 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6056"; a="48847468"
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
From: Daniel Walker <dwalker@codeaurora.org>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
In-Reply-To: <1280270466-13503-1-git-send-email-stepanm@codeaurora.org>
References: <1280270466-13503-1-git-send-email-stepanm@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 15:43:37 -0700
Message-ID: <1280270617.16382.5.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-27 at 15:41 -0700, Stepan Moskovchenko wrote:
> +/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions are
> + * met:
> + *     * Redistributions of source code must retain the above copyright
> + *       notice, this list of conditions and the following disclaimer.
> + *     * Redistributions in binary form must reproduce the above
> + *       copyright notice, this list of conditions and the following
> + *       disclaimer in the documentation and/or other materials provided
> + *       with the distribution.
> + *     * Neither the name of Code Aurora Forum, Inc. nor the names of its
> + *       contributors may be used to endorse or promote products derived
> + *       from this software without specific prior written permission. 


This should be GPLv2 ..

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

