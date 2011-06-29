Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703Ab1F2X65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 19:58:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab1F2X6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 19:58:52 -0400
Date: Wed, 29 Jun 2011 12:06:42 -0700
From: Greg KH <gregkh@suse.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] Staging: hv: Integrate the time source driver with
 Hyper-V detection code
Message-ID: <20110629190642.GA19698@suse.de>
References: <1309374364-23528-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309374364-23528-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 12:06:04PM -0700, K. Y. Srinivasan wrote:
> The Hyper-V timesource driver is best integrated with Hyper-V detection code
> since: (a) Linux guests running on Hyper-V need this timesource and (b)
> by integrating with Hyper-V detection, we could minimize the code in the 
> timesource driver. Greg, you had  helped me initially in getting the Hyper-V
> detection code into the kernel (mshyperv.c). I am hoping you can take
> this patch. 

Nope, it needs to go through the x86 maintainers, please resend it to
them.  The scripts/get_maintainer.pl file should have told you this,
right?

thanks,

greg k-h
