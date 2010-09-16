Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab0IPX76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 19:59:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738Ab0IPX75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 19:59:57 -0400
Date: Thu, 16 Sep 2010 16:58:29 -0700
From: Greg KH <gregkh@suse.de>
To: pavan_savoy@ti.com
Cc: alan@lxorguk.ukuu.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] prepare ti-st to mv out of staging
Message-ID: <20100916235829.GA26521@suse.de>
References: <1284684572-12508-1-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284684572-12508-1-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 08:49:29PM -0400, pavan_savoy@ti.com wrote:
> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> Greg,
> 
> As suggested, the patch has been spilt to 3 patches:
> 1. corrects the data types
> 2. moves all headers to 1 file
> 3. sources are modified to make use of the newly created header file

Almost.

Never create a patch that breaks the build.  Your patch #2 did that,
right?

Care to merge number 2 and 3 together?

thanks,

greg k-h
