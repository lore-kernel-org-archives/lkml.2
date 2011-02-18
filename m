Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1BRVP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 16:15:29 -0500
Received: from kroah.org ([198.145.64.141]:48311 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab1BRVP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 16:15:27 -0500
Date: Fri, 18 Feb 2011 13:14:23 -0800
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: Re: [PATCH]: Staging: hv: Allocate the vmbus irq dynamically
Message-ID: <20110218211423.GH796@kroah.com>
References: <1297799735-25917-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297799735-25917-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 11:55:35AM -0800, K. Y. Srinivasan wrote:
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

You didn't run this through checkpatch.pl.

Please do so and fix the warning it gives you.

thanks,

greg k-h
