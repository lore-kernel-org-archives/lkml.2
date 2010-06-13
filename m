Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab0FMFgO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 01:36:14 -0400
Received: from mail.perches.com ([173.55.12.10]:1106 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab0FMFgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 01:36:13 -0400
Subject: Re: [PATCH] checkpatch.pl skip long lines
From: Joe Perches <joe@perches.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Fredrik Gustafsson <iveqy@iveqy.com>, apw@canonical.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100613010429.GA31692@pengutronix.de>
References: <20100612170944.GA9121@iveqy.com>
	 <20100613010429.GA31692@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Jun 2010 22:36:12 -0700
Message-ID: <1276407372.1449.33.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-13 at 03:04 +0200, Wolfram Sang wrote:
> On Sat, Jun 12, 2010 at 07:09:44PM +0200, Fredrik Gustafsson wrote:
> 
> > since the number of long lines in the linux kernel is huge and since
> > Greg Kroah Hartman in his google tech talk about the kernel
> > (http://www.youtube.com/watch?v=L2SED6sewRw) talked about probably
> > ignore that criteria in the future, I thought the checkpatch.pl script
> > should have an option to ignore checking for long lines.
> > 
> > This would help finding the real errors and warnings, because they don't
> > drown in line length warnings.
> 
> Instead of adding another command-line option, I'd suggest to just use CHK
> instead of WARN, so this check will be enabled with --strict. I wonder if there
> is already consensus on deprecating the 80-char-rule?

Nope.  There's a vocal contingent that doesn't like it though.
An earlier thread and suggested patch below.
http://lkml.org/lkml/2009/12/18/3


