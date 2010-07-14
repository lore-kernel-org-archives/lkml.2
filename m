Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab0GNW3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:29:48 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21605 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318Ab0GNW3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:29:46 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6043"; a="47348981"
Subject: Re: [PATCH 10/11] staging: msm: formatting of pointers in printk()
From: Daniel Walker <dwalker@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <201007141528.43290.davidb@codeaurora.org>
References: <1279130759-17608-1-git-send-email-segooon@gmail.com>
	 <201007141528.43290.davidb@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Jul 2010 15:29:37 -0700
Message-ID: <1279146577.22623.7.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-14 at 15:28 -0700, David Brown wrote:
> On Wednesday 14 July 2010 11:05:58 Kulikov Vasiliy wrote:
> 
> > Use %p instead of %08x in printk().
> > 
> > Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> 
> Acked-by: David Brown <davidb@codeaurora.org>

yeah, it looks fine to me too.

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

