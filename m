Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab1DFOR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:17:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35606 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986Ab1DFOR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:17:56 -0400
Date: Wed, 6 Apr 2011 07:03:26 -0700
From: Greg KH <gregkh@suse.de>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Hank Janssen <hjanssen@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: hv_mouse: Fix build error
Message-ID: <20110406140326.GA20688@suse.de>
References: <1302084896-25250-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302084896-25250-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 12:14:56PM +0200, Joerg Roedel wrote:
> The compiler argues about the implictly declared udelay
> function. Fix it by adding the appropriate include.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Already queued up to go to Linus in the linux-next tree.

thanks,

greg k-h
