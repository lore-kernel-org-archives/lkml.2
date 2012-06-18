Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab2FRPA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:00:27 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37193 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab2FRPA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:00:26 -0400
Date: Mon, 18 Jun 2012 17:59:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Miguel =?iso-8859-1?Q?G=F3mez?= <magomez@igalia.com>
Cc: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] Staging: xgifb: remove DPRINTK() macro and replace
 it with pr_debug.
Message-ID: <20120618145934.GK4400@mwanda>
References: <cover.1340016625.git.magomez@igalia.com>
 <ae46504eae191c2b2648cdcae8a27c9c7b03e69f.1340016625.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ae46504eae191c2b2648cdcae8a27c9c7b03e69f.1340016625.git.magomez@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 01:12:01PM +0200, Miguel Gómez wrote:
>  			} else if (XGIfb_vrate[i].refresh > rate) {
>  				if ((XGIfb_vrate[i].refresh - rate) <= 3) {
> -					DPRINTK("XGIfb: Adjusting rate from %d up to %d\n",
> -						rate, XGIfb_vrate[i].refresh);
> +					pr_debug("XGIfb: Adjusting rate from %d up to %d\n",
> +						 rate, XGIfb_vrate[i].refresh);

This file already has a pr_fmt set so if you wanted, you could just
remove the "XGIfb: ".  This was already there in the original code
so don't resend.  But if you want to send another patch which
removes them that would be grand.

regards,
dan carpenter


