Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab1BVO7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:59:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51500 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab1BVO7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:59:53 -0500
Date: Tue, 22 Feb 2011 06:54:52 -0800
From: Greg KH <gregkh@suse.de>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: remove null checks before kfree
Message-ID: <20110222145452.GD1331@suse.de>
References: <1298364821-18915-1-git-send-email-imirkin@alum.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298364821-18915-1-git-send-email-imirkin@alum.mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 03:53:40AM -0500, Ilia Mirkin wrote:
> This patch was created with the following semantic patch:
> 
> // <smpl>
> @@
> expression E;
> @@
> 
> - if (E != NULL) kfree(E);
> + kfree(E);
> // </smpl>
> 
> Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
> ---
> 
> Hi Greg,
> 
> Please let me know if you would rather I split these up by driver instead.
> I didn't because I saw that you took staging-wide cleanups before.

Please split these up per-driver, it makes it easier to merge and for
the individual driver authors to review them.

thanks,

greg k-h
