Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab2IGW66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 18:58:58 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28929 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2IGW6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 18:58:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6828"; a="234282503"
Date: Fri, 7 Sep 2012 15:58:53 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Bryan Huntsman <bryanh@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 8/9] ARM: msm: Add DT support for 8960
Message-ID: <20120907225853.GA21585@codeaurora.org>
References: <1346873339-10927-1-git-send-email-sboyd@codeaurora.org>
 <1346873339-10927-9-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346873339-10927-9-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 12:28:58PM -0700, Stephen Boyd wrote:

> +DT_MACHINE_START(MSM8960_DT, "Qualcomm MSM (Flattened Device Tree)")

The description string should specify the general name of what this is
suspporting.  Right now, with these patches, it would list

  Qualcomm MSM (Flattened Device Tree)

twice as the two targets we support (and isn't helpful when you see
which one it picks).  I'd put the "MSM" name by itself without
thinking about it too much.  It wasn't that confusing, since there was
only one at the time.

Perhaps make the 8660 one "Qualcomm MSM8660 (Flattened Device Tree)"
and the 8960 one "Qualcomm MSM8960 (Flattened Device Tree)"

I realize that the chip numbers are a bit confusing, so probably best
to pick a canonical name for the description.

David

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
