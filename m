Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343Ab0LTXmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:42:10 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58500 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933273Ab0LTXmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:42:08 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67418039"
Date: Mon, 20 Dec 2010 15:42:06 -0800
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] mmc: msm: consolidate ifdefs for BUSCLK_PWRSAVE
Message-ID: <20101220234206.GA15270@huya.qualcomm.com>
References: <1292887011-30006-1-git-send-email-dwalker@codeaurora.org>
 <20101220233519.GA14582@huya.qualcomm.com>
 <1292888350.27552.22.camel@m0nster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292888350.27552.22.camel@m0nster>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 03:39:10PM -0800, Daniel Walker wrote:
> > I this feature even used?  It looks like some kind debug feature.
> 
> Yeah it's used, it's default on..

What I meant was "is there any reason to be able to turn this off."
It looks like something that would be used during development, and
doesn't need to be disabled once the driver works.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
