Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab1ARElK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 23:41:10 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:43317 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab1ARElI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 23:41:08 -0500
Date: Tue, 18 Jan 2011 13:38:51 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Daniel Mack <daniel@caiaq.de>,
        Janine Kropp <nin@directfb.org>, Denis Oliver Kropp <dok@directfb.org>,
        Eric Miao <eric.y.miao@gmail.com>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] video: pxa3xx-gcu: Return -EFAULT when copy_from_user() fails
Message-ID: <20110118043851.GH2122@linux-sh.org>
References: <1294997951.12295.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294997951.12295.1.camel@mola>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 05:39:11PM +0800, Axel Lin wrote:
> Return -EFAULT instead of number of bytes that could not be copied if
> copy_from_user() fails.
> 
> Also fix a typo in the comments.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.
