Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab2FNLv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:51:26 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:38793 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab2FNLvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:51:25 -0400
Date: Thu, 14 Jun 2012 14:50:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/14] staging/xgifb: Cleanup vb_device_info struct
Message-ID: <20120614115055.GY13539@mwanda>
References: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
 <1339626112-20671-14-git-send-email-peterhuewe@gmx.de>
 <20120614093655.GW13539@mwanda>
 <bf2c5063-2ce7-40f8-9980-04d1666eb76f@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf2c5063-2ce7-40f8-9980-04d1666eb76f@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 01:07:47PM +0200, Peter Huewe wrote:
> Hi Dan, 
> Thanks for the feedback.
> I agree somewhat with you that the patch is quite big and complex, that's why I added the seperators in the commit message, but when I created the patch it seemed logical enough (to me :) to keep it as one.
> 
> Greg already pulled it in, but if you still want it split up I could do that for you -just let me know.
> However I'm not sure if then the smaller chunks should be merged or the big one.
> 

No no.  Forget about it.  It's a blurry line which patches are too
complicated to do in one go.  You got one through the gauntlet.
Next time you might not be so lucky.  ;)

Btw, I think this series is great.  I'm always in favour of deleting
code.

regards,
dan carpenter

