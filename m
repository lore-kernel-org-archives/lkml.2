Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab1HWV2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 17:28:17 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:49264 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754948Ab1HWV2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 17:28:09 -0400
X-Sasl-enc: WUKJ5W0u6z4uRtSWHaiMCEXo7cI0JAC2x3slQEyjSy79 1314134888
Date: Tue, 23 Aug 2011 14:20:34 -0700
From: Greg KH <greg@kroah.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: apatard@mandriva.com, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] staging: xgifb: misc cleanups
Message-ID: <20110823212034.GA3679@kroah.com>
References: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 10:40:18PM +0300, Aaro Koskinen wrote:
> Hi,
> 
> Here's some miscellaneous cleanups for the xgifb staging driver. There
> are no functional changes, except one printk() message is gone.
> 
> The patch number 8 will give you checkpatch warnings, but those are not
> introduced by these changes. The actual change is very simple as can be
> seen with "diff -w".

Not all of these applied, care to resync with the staging-next tree and
resend anything that I missed?

thanks,

greg k-h
