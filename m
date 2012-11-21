Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab2KUNFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:05:52 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22099 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab2KUNFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:05:51 -0500
Date: Wed, 21 Nov 2012 16:05:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rupesh Gujare <rgujare@ozmodevices.com>
Cc: devel@driverdev.osuosl.org, sachin.kamat@linaro.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [V2 PATCH 1/3] staging: ozwpan: Remove redundant null check
 before kfree in ozpd.c
Message-ID: <20121121130527.GH11248@mwanda>
References: <20121120163513.GC4990@kroah.com>
 <1353501977-6585-2-git-send-email-rgujare@ozmodevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353501977-6585-2-git-send-email-rgujare@ozmodevices.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 12:46:15PM +0000, Rupesh Gujare wrote:
> Call kfree only if required else return from function.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Signed-off-by: Rupesh Gujare <rgujare@ozmodevices.com>

I'm not sure this is right.

Signed-off-by is intended to have a legal meaning that you are
signing off that you have permission to submit the patch.  You're
not allowed to sign off on behalf of someone else.

If we apply this as is, then you get the author credit.  If you want
to give Sachin author credit then make the first line of the email:

From: Sachin Kamat <sachin.kamat@linaro.org>

Also it's not a good idea to get too control freaky over this code
which is all going to have to be replaced before this can graduate
out of staging.  You're just going to discourage people from
contributing if you redo all their patches.  Linaro people are the
real deal and you should let them help.

regards,
dan carpenter

