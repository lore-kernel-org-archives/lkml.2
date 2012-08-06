Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab2HFJGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:06:18 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:21065 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab2HFJGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:06:15 -0400
Date: Mon, 6 Aug 2012 12:06:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Damien Cassou <damien.cassou@lifl.fr>
Cc: David Brown <davidb@codeaurora.org>, kernel-janitors@vger.kernel.org,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-arm-msm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] drivers/video/msm/mddi_client_nt35399.c: use devm_
 functions
Message-ID: <20120806090602.GL4352@mwanda>
References: <1344008414-2894-1-git-send-email-damien.cassou@lifl.fr>
 <1344008414-2894-5-git-send-email-damien.cassou@lifl.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344008414-2894-5-git-send-email-damien.cassou@lifl.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 05:40:13PM +0200, Damien Cassou wrote:
> @@ -233,7 +234,6 @@ static int mddi_nt35399_remove(struct platform_device *pdev)
>  	struct panel_info *panel = platform_get_drvdata(pdev);
> 
>  	setup_vsync(panel, 0);
> -	kfree(panel);
>  	return 0;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in

It's weird.  This patch doesn't apply for me unless I add a blank
line between the "}" and the "--".  I'm not sure if that line is
getting removed by your email client or by the kernel janitors email
list.

regards,
dan carpenter

