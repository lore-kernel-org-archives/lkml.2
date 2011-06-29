Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab1F2E1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 00:27:46 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:45679 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750942Ab1F2E1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 00:27:40 -0400
X-Sasl-enc: HIczV/R9VEOkCwFPxZdtX2f776C0P7jsk/Y9AMBgzrsF 1309321659
Date: Tue, 28 Jun 2011 21:21:24 -0700
From: Greg KH <greg@kroah.com>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: use videobuf2 framework for
 drivers/staging/dt3155v4l driver
Message-ID: <20110629042124.GA18344@kroah.com>
References: <201105282145.27809.mitov@issp.bas.bg>
 <20110628202515.GA9177@kroah.com>
 <201106290646.02960.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106290646.02960.mitov@issp.bas.bg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 06:46:02AM +0300, Marin Mitov wrote:
> On Tuesday, June 28, 2011 11:25:15 pm Greg KH wrote:
> > On Sat, May 28, 2011 at 09:45:27PM +0300, Marin Mitov wrote:
> > > This patch transforms drivers/staging/dt3155v4l driver to use videobuf2 framework.
> > > Tested and works with "xawtv -f".
> > > 
> > > Either streaming API or read method should be selected during kernel configuration.
> > 
> > I've applied this, but why would you ever not want to use the streaming
> > api?
> 
> There are no reasons for that, sure, but for now xawtv do not work if both are
> specified in the driver. I have to debug it.

Ok, but why not just remove the read method then?  Or do some userspace
programs still require it?

greg k-h
