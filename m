Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab1IAUb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 16:31:26 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:57751 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695Ab1IAUbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 16:31:23 -0400
X-Sasl-enc: QYpo28IThNOX4i9e6+ZQEIUlVZDftiX3vk8yLI+wWWWL 1314909082
Date: Thu, 1 Sep 2011 13:31:13 -0700
From: Greg KH <greg@kroah.com>
To: Peter Foley <pefoley2@verizon.net>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@suse.de,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: Re: Hyper-V TODO file
Message-ID: <20110901203113.GA15259@kroah.com>
References: <1314829011-28922-1-git-send-email-kys@microsoft.com>
 <alpine.LNX.2.00.1108311907130.20924@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1108311907130.20924@linux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 07:11:39PM -0400, Peter Foley wrote:
> On Wed, 31 Aug 2011, K. Y. Srinivasan wrote:
> > Greg, as I have been pestering you for some time now, we are very interested in
> > exiting staging and we are willing to dedicate the necessary development 
> > resources to address whatever issues that may still be pending. So, your help
> > in identifying what needs to be done will be greatly appreciated. To that end,
> > I think it will be useful to update the TODO file to reflect the current state of
> > the drivers. Let us know how we should proceed here. 
>  
> An issue I've come across in the hyper-v drivers is the forced modular 
> build. You might want to see if the "depends on m" is still needed.

Ah, good point, KY, can you try this out and see if that can be changed?
If not, something is wrong and that needs to get fixed.

thanks,

greg k-h
