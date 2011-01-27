Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab1A0TA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 14:00:58 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59508 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab1A0TA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 14:00:56 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6239"; a="72226413"
From: David Brown <davidb@codeaurora.org>
To: Julia Lawall <julia@diku.dk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, kernel-janitors@vger.kernel.org,
        Daniel Walker <dwalker@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers/staging/msm/lcdc.c: Convert IS_ERR result to PTR_ERR
In-Reply-To: <1296143347-17508-2-git-send-email-julia@diku.dk> (Julia Lawall's
	message of "Thu, 27 Jan 2011 16:49:07 +0100")
References: <1296143347-17508-2-git-send-email-julia@diku.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110127:adharmap@codeaurora.org::85KihSOhpkvEUSUo:000000000000000000000000000000000000000Kph
X-Hashcash: 1:20:110127:gregkh@suse.de::y5KuLXb6Oje84Q3T:0002Fx9
X-Hashcash: 1:20:110127:linux-kernel@vger.kernel.org::fXwGC/GsFppOoM+e:0000000000000000000000000000000001k4+
X-Hashcash: 1:20:110127:stepanm@codeaurora.org::Tn8nafp3A44fF6gs:0000000000000000000000000000000000000001SSP
X-Hashcash: 1:20:110127:julia@diku.dk::TdA7F9bApisL4om7:000029Ny
X-Hashcash: 1:20:110127:kernel-janitors@vger.kernel.org::BM581gpxcVpnFh2R:0000000000000000000000000000009ouV
X-Hashcash: 1:20:110127:devel@driverdev.osuosl.org::iKb0GKawL14ol6uB:000000000000000000000000000000000008w/h
X-Hashcash: 1:20:110127:dwalker@codeaurora.org::wtjX2VZCCOuk1kPi:000000000000000000000000000000000000000HiDS
Date: Thu, 27 Jan 2011 11:00:55 -0800
Message-ID: <8yabp325fyw.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27 2011, Julia Lawall wrote:

> This code elsewhere returns a negative constant to an indicate an error,
> while IS_ERR returns the result of a >= operation.
>
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: David Brown <davidb@codeaurora.org>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
