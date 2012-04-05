Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab2DEAkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 20:40:21 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46923 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756543Ab2DEAkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 20:40:20 -0400
Message-ID: <1333586419.23520.52.camel@joe2Laptop>
Subject: Re: [PATCH] printk: support structured and multi-facility log
 messages
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartmann <greg@kroah.com>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Date: Wed, 04 Apr 2012 17:40:19 -0700
In-Reply-To: <20120405003321.GB27595@kroah.com>
References: <1333569554.864.3.camel@mop>
	 <1333583480.23520.37.camel@joe2Laptop> <20120405003321.GB27595@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-04 at 17:33 -0700, Greg Kroah-Hartmann wrote:
> On Wed, Apr 04, 2012 at 04:51:20PM -0700, Joe Perches wrote:
> > On Wed, 2012-04-04 at 21:59 +0200, Kay Sievers wrote:
> > > From: Kay Sievers <kay@vrfy.org>
> > > Subject: printk: support structured and multi-facility log messages
> > []
> > > This patch extends printk() to be able to attach arbitrary key/value
> > > pairs to logged messages,
> > How does it do that?
> The implementation doesn't show that?

Not so far as I can tell.

How are arbitrary key/value pairs attached
in a printk?

> > []
> > 
> > > - Records consume almost the same amount, sometimes less memory than
> > >   the traditional byte stream buffer (if printk_time is enabled). The record
> > >   header is 16 bytes long, plus some padding bytes at the end if needed.
> > >   The byte-stream buffer needed 3 chars for the syslog prefix, 15 char for
> > >   the timestamp and a newline.
> > 
> > I suggest using lzo on the string portion.
> 
> As the used overall size is pretty much the same, that doesn't really
> seem necessary to me.

As dmesg output would still exist, compression could reduce
the size of the duplicated logged output buffers significantly.


