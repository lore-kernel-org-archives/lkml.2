Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1DSREO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 13:04:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:50665 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529Ab1DSREN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 13:04:13 -0400
Subject: Re: [BISECTED] QLogic Corp. ISP2532-based 8Gb Fibre Channel not
 working on 2.6.35.y
From: James Bottomley <James.Bottomley@suse.de>
To: Andi Kleen <ak@linux.intel.com>
Cc: Ozan =?UTF-8?Q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
        stable@kernel.org, giridhar.malavali@qlogic.com,
        linux-kernel@vger.kernel.org, andrew.vasquez@qlogic.com
In-Reply-To: <20110419165801.GA17788@tassilo.jf.intel.com>
References: <4DAD5495.5060704@pardus.org.tr>
	 <20110419165801.GA17788@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 12:04:08 -0500
Message-ID: <1303232648.3171.22.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 09:58 -0700, Andi Kleen wrote:
> > From 2f0f3f4f06f7cfadebf58b70bd9e7f71d8fd96e4 Mon Sep 17 00:00:00 2001
> > From: Madhuranath Iyengar <madhuranath.iyengar@qlogic.com>
> > Date: Fri, 23 Jul 2010 15:28:24 +0500
> > Subject: [PATCH 021/107] [SCSI] qla2xxx: Appropriately log FCP
> > priority data messages
> > 
> > Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> > Signed-off-by: James Bottomley <James.Bottomley@suse.de>
> > 
> > 
> > -------
> > 
> > So I think at least the first commit that I've mentioned should be
> > queued for the next 2.6.35.y to fix this issue.
> 
> Thanks for the bisection.
> 
> Can I get an ack for that from the driver or SCSI maintainer or
> patch author first please?
> I don't understand the driver well enough to make a call myself.

I'll defer to qlogic ... it looks like a driver enhancement to add FCP
prioritised queues ... but it would be a bug fix, I suppose, if the card
can't actually operate without this.

James


