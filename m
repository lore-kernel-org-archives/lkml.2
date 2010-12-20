Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302Ab0LTXfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:35:22 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62310 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab0LTXfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:35:21 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67627073"
Date: Mon, 20 Dec 2010 15:35:19 -0800
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: davidb@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] mmc: msm: consolidate ifdefs for BUSCLK_PWRSAVE
Message-ID: <20101220233519.GA14582@huya.qualcomm.com>
References: <1292887011-30006-1-git-send-email-dwalker@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292887011-30006-1-git-send-email-dwalker@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 03:16:47PM -0800, Daniel Walker wrote:

> It's cleaner to have ifdef's consolidated in one specific
> area. This change pulls adds one ifdef which will swap
> out of the function with a stub function if the ifdef is
> false.

It also changes the define from #if checks to #ifdef which changes how
it would be used.

I this feature even used?  It looks like some kind debug feature.

David
