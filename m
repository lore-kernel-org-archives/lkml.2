Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab2AET1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 14:27:46 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54191 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932516Ab2AET1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 14:27:17 -0500
X-Sasl-enc: 41Chjmw0h2o63+w4wo5WfZ+W7avyfiSHcXfVBgwbjLDi 1325791636
Date: Thu, 5 Jan 2012 11:26:58 -0800
From: Greg KH <greg@kroah.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [00/67] 3.0.16-stable review
Message-ID: <20120105192658.GA27893@kroah.com>
References: <20120103223043.GA26738@kroah.com>
 <20120105191813.GA5762@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105191813.GA5762@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 11:18:13AM -0800, Greg KH wrote:
> On Tue, Jan 03, 2012 at 02:30:43PM -0800, Greg KH wrote:
> > This is the start of the stable review cycle for the 3.0.16 release.
> > There are 67 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let us know.  If anyone is a maintainer of the proper subsystem, and
> > wants to add a Signed-off-by: line to the patch, please respond with it.
> > 
> > Responses should be made by Friday, January 6, 2012, 20:00:00 UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.16-rc1.gz
> > and the diffstat can be found below.
> 
> Due to a few noted issues in this series, and a few last-minute
> straggler patches being applied to the final 3.2 release, there's a new
> 3.0.16-rc2 release, which can be found at:
>  	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.16-rc1.gz

Doh, that should be:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.16-rc2.gz

Sorry about that.

greg k-h
