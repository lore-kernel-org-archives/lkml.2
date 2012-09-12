Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab2ILILj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:11:39 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31859 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab2ILILf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:11:35 -0400
Date: Wed, 12 Sep 2012 11:11:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, b-cousson@ti.com,
        j-keerthy@ti.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/4] staging: omap-thermal: Correct checkpatch.pl warnings
Message-ID: <20120912081127.GB19396@mwanda>
References: <1347379615-6881-1-git-send-email-eduardo.valentin@ti.com>
 <1347379615-6881-2-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347379615-6881-2-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 07:06:52PM +0300, Eduardo Valentin wrote:
> From: J Keerthy <j-keerthy@ti.com>
> 
> Removes checkpatch warnings on omap-bandgap.c.
> 

Which checkpatch.pl warnings?

> +				omap_bandgap_writel(bg_ptr,
> +					rval->tshut_threshold,
> +						   tsr->tshut_threshold);

That's just whacky.

Personally, I've never cared much about long lines, so I'd prefer
to leave these as is until someone can break the functions up and
remove them in a proper way instead of just shifting everything
randomly to the left.

regards,
dan carpenter

