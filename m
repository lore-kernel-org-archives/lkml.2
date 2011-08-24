Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1HXXNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 19:13:37 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:47531 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751948Ab1HXXNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 19:13:35 -0400
X-Sasl-enc: MHJYvkCCpjrj7aIddjrhRySriKQa5gdmT0EOVkrPucLE 1314227615
Date: Wed, 24 Aug 2011 16:11:46 -0700
From: Greg KH <greg@kroah.com>
To: Jason Stubbs <jasonbstubbs@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform: fix samsung brightness min/max calculations
Message-ID: <20110824231146.GB7697@kroah.com>
References: <201104201358.50443.jasonbstubbs@gmail.com>
 <201105132044.25928.jasonbstubbs@gmail.com>
 <20110613235549.GA14762@kroah.com>
 <201106200736.29259.jasonbstubbs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106200736.29259.jasonbstubbs@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 07:36:29AM +1000, Jason Stubbs wrote:
> > Any chance you want to take over maintaining this driver now yourself?
> > You seem to have a much better understanding of it in places than I do
> > at the moment, combined with a strong need to keep it working properly
> 
> I'm not exactly sure what that entails, but I don't have access to any specs
> and have never dealt with any hardware programming before. Even these patches
> don't directly deal with the hardware so I'm not sure that I'm best suited to
> being the maintainer. Having said that, I'm happy to try my hand at any bugs
> that arise and review any patches..

I don't have access to any specs either.  Reviewing and handling the
patches and forwarding them on to the platform driver maintainer is all
that is needed.

Feel free to send me a patch adding you to the MAINTAINERS file.

thanks,

greg k-h
