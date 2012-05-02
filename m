Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab2EBUVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:21:38 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35362 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757100Ab2EBUVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:21:36 -0400
X-Sasl-enc: Qpwn6ORbz3ccE5R4ZC2P7r9VX+lVEbCZQ4UXBlhVAdaR 1335990095
Date: Wed, 2 May 2012 13:21:34 -0700
From: Greg KH <greg@kroah.com>
To: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Add 1-wire slave device driver for DS28E04-100
Message-ID: <20120502202134.GB26628@kroah.com>
References: <20120430021300.GA18148@kroah.com>
 <4FA1953B.40008@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA1953B.40008@hrz.tu-chemnitz.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 10:12:43PM +0200, Markus Franke wrote:
> Dear Greg,
> 
> Am 30.04.2012 04:13, schrieb Greg KH:
> >On Thu, Apr 12, 2012 at 12:40:30AM +0200, Markus Franke wrote:
> >>This patch adds a 1-wire slave device driver for the DS28E04-100.
> >>
> >>Signed-off-by: Markus Franke<franm@hrz.tu-chemnitz.de>
> >>Acked-by: Evgeniy Polyakov<zbr@ioremap.net>
> >
> >You have a lot of checkpatch warnings and errors, and you are creating
> 
> Don't have a clue what you mean. You were able to apply the patch
> successfully in the past.

Applying it was fine, but the patch created lots of problems if you ran
it through the scripts/checkpatch.pl tool.  Please fix all of those
warnings and errors up.

> >new sysfs files with no documentation at all as to what you are doing,
> >and why you are doing it.  sysfs binary files at that, which should not
> >be used by ANY code that is trying to intrepret the data being sent to
> >those files, sysfs binary files are for "pass-through" mode only.
> 
> Well, I just stuck to the way things are done in already existing
> drivers e.g. drivers/w1/slaves/w1_ds2433.c

Really?  Ick, where are those files documented?

greg k-h
