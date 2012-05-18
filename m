Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966519Ab2ERSXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 14:23:05 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46867 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966482Ab2ERSW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 14:22:59 -0400
X-Sasl-enc: 2lYxKtOZPgi6lXKo2fjnxA7ZHSqCbmqAYWVPx32R3cSg 1337365377
Date: Fri, 18 May 2012 11:22:56 -0700
From: Greg KH <greg@kroah.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/53] 3.2.18-stable review
Message-ID: <20120518182256.GC31313@kroah.com>
References: <20120518023254.339945758@decadent.org.uk>
 <20120518144657.GA18264@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518144657.GA18264@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 10:46:57AM -0400, Steven Rostedt wrote:
> On Fri, May 18, 2012 at 03:32:54AM +0100, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.2.18 release.
> > There are 53 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun May 20 13:00:00 UTC 2012.
> > Anything received after that time might be too late.
> > 
> > The whole patch series should soon be available in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.x/stable-review/patch-3.2.18-rc1.gz
> > and the diffstat can be found below.
> 
> $ wget  kernel.org/pub/linux/kernel/v3.x/stable-review/patch-3.2.18-rc1.gz
> --2012-05-18 10:44:23--  http://kernel.org/pub/linux/kernel/v3.x/stable-review/patch-3.2.18-rc1.gz
> Resolving kernel.org (kernel.org)... 149.20.4.69
> Connecting to kernel.org (kernel.org)|149.20.4.69|:80... connected.
> HTTP request sent, awaiting response... 404 Not Found
> 2012-05-18 10:44:23 ERROR 404: Not Found.
> 
> How much is "soon"? Did you push it to the repo yet and I'm just waiting
> on the mirroring? Or do you still need to push it yourself?

Normally I push it, as I don't think Ben has the permissions to do it at
the moment.

Ben, care to put the tarball somewhere so I can update it, or should I
be poking the kernel.org admins to get you write access to this
directory (I think the later would be best...)

thanks,

greg k-h
