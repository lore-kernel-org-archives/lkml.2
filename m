Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab2KWGn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 01:43:28 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:39808 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768Ab2KWGn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 01:43:26 -0500
Date: Fri, 23 Nov 2012 09:43:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, Tomas M <tomas@slax.org>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        Mihail Kasadjikov <hamer.mk@gmail.com>
Subject: Re: [PATCH] staging: zram: Prevent use of unmapped buffer
Message-ID: <20121123064259.GJ11248@mwanda>
References: <1353580873-5227-1-git-send-email-ngupta@vflare.org>
 <20121123001709.GF5121@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121123001709.GF5121@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 09:17:09AM +0900, Minchan Kim wrote:
> Hi Nitin,
> 
> Current next-20121115(I don't know why linux-next stay at the version. Is there
> any problem on the tree? or Stephen go to holiday?)

Yep.  He'll be back on Monday.

regards,
dan carpenter

