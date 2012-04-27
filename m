Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab2D0Hm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 03:42:29 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:28342 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963Ab2D0Hm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 03:42:27 -0400
Date: Fri, 27 Apr 2012 10:44:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Javier M. Mellid" <jmunhoz@igalia.com>
Cc: gregkh@linuxfoundation.org, gewang@siliconmotion.com,
        boyod.yang@siliconmotion.com.cn, wuzhangjin@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/7] staging: sm7xx: code improvements and cleanup
Message-ID: <20120427074448.GG6447@mwanda>
References: <20120425205532.GA9642@kroah.com>
 <1335465955-32057-1-git-send-email-jmunhoz@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335465955-32057-1-git-send-email-jmunhoz@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 08:45:48PM +0200, Javier M. Mellid wrote:
> This set of patches implement some code improvements, dead code removal
> and cleanup. New code uses dynamic debug support.
> 
> The patches address new checkpatch warnings.
> 
> Patches tested with SM712.
> 

Thanks for breaking that up into separate patches.  Nicely done.

regards,
dan carpenter

