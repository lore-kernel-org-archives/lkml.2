Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1HQUId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:08:33 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28069 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab1HQUIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:08:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6441"; a="111055937"
Date: Wed, 17 Aug 2011 13:08:30 -0700
From: David Brown <davidb@codeaurora.org>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: Re: [patch 32/36] Hexagon: Comet platform support
Message-ID: <20110817200830.GB22064@huya.qualcomm.com>
References: <20110817163457.878854582@codeaurora.org>
 <20110817163522.852412019@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110817163522.852412019@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 11:35:29AM -0500, Richard Kuo wrote:

> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-hexagon-kernel/arch/hexagon/configs/comet_defconfig	2011-07-20 15:19:44.785151291 -0500
> @@ -0,0 +1,873 @@
> +#
> +# Automatically generated make config: don't edit
> +# Linux/hexagon 2.6.39-rc5 Kernel Configuration
> +# Wed May  4 16:08:56 2011

This should be a shrunk defconfig.  If you 'make savedefconfig', it'll
make a shortened version of this file that will only contain fields
that are set to non-default values.  It reduces the amount of churn on
these files (and also just makes them a lot smaller).

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
