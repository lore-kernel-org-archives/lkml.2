Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab2LMIRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 03:17:09 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:40264 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab2LMIRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 03:17:08 -0500
Date: Thu, 13 Dec 2012 11:16:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Laurent Navet <laurent.navet@gmail.com>
Cc: linux-kernel@vger.kernel.org, bskeggs@redhat.com,
        dri-devel@lists.freedesktops.org, airlied@linux.ie,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers: nouveau: Bool tests don't need comparison
Message-ID: <20121213081657.GV6568@mwanda>
References: <1355320451-23292-1-git-send-email-laurent.navet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355320451-23292-1-git-send-email-laurent.navet@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 02:54:10PM +0100, Laurent Navet wrote:
>  Bool initializations should use true and false.  Bool tests don't need
>  comparisons.  Based on contributions from Joe Perches, Rusty Russell
>  and Bruce W Allan.
> 
>  The semantic patch that makes this output is available
>  in scripts/coccinelle/misc/boolinit.cocci.
> 
>  More information about semantic patching is available at
>  http://coccinelle.lip6.fr/
> 

For some reason the commit message is indented by one space.  Don't
do whatever caused that.

regards,
dan carpenter

