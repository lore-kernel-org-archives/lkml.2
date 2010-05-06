Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab0EFGCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:02:46 -0400
Received: from kroah.org ([198.145.64.141]:44750 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab0EFGCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:02:44 -0400
Date: Wed, 5 May 2010 23:03:26 -0700
From: Greg KH <greg@kroah.com>
To: roma1390 <roma1390@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] nfs kernel server causes: kernel BUG at
	include/linux/module.h:386!
Message-ID: <20100506060326.GA20846@kroah.com>
References: <4BE257EF.9050904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE257EF.9050904@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 08:47:27AM +0300, roma1390 wrote:
> Hello,
>
> after some nfs server start/stop i hit kernel bug on 2.6.26. There is 
> hope[1] that this bug is fixed[2], and fix is merged[3] into 2.6.29. But 
> there is missing bugfix for older stable kernels.

2.6.26 is not supported by the community anymore.

Is this a problem on the latest 2.6.27-stable kernel release?  If so,
which specific patches in Linus's tree do you think resolves this?  Is
it just the 22945e4a1c7454c97f5d8aee1ef526 commit that is needed to be
added there?

thanks,

greg k-h
