Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab2DEAdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 20:33:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56824 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757211Ab2DEAdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 20:33:23 -0400
X-Sasl-enc: 7u0ZdFbYiZTLlwYxlCoxvD+FVq/pX6aK8HyrCrRyoEBQ 1333586003
Date: Wed, 4 Apr 2012 17:33:21 -0700
From: Greg Kroah-Hartmann <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: support structured and multi-facility log
 messages
Message-ID: <20120405003321.GB27595@kroah.com>
References: <1333569554.864.3.camel@mop>
 <1333583480.23520.37.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333583480.23520.37.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 04:51:20PM -0700, Joe Perches wrote:
> On Wed, 2012-04-04 at 21:59 +0200, Kay Sievers wrote:
> > From: Kay Sievers <kay@vrfy.org>
> > Subject: printk: support structured and multi-facility log messages
> []
> > This patch extends printk() to be able to attach arbitrary key/value
> > pairs to logged messages,
> 
> How does it do that?

The implementation doesn't show that?

> []
> 
> > - Records consume almost the same amount, sometimes less memory than
> >   the traditional byte stream buffer (if printk_time is enabled). The record
> >   header is 16 bytes long, plus some padding bytes at the end if needed.
> >   The byte-stream buffer needed 3 chars for the syslog prefix, 15 char for
> >   the timestamp and a newline.
> 
> I suggest using lzo on the string portion.

As the used overall size is pretty much the same, that doesn't really
seem necessary to me.

thanks,

greg k-h
