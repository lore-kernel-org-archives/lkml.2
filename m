Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab0LOXDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 18:03:48 -0500
Received: from ns2.cypress.com ([157.95.67.5]:57766 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab0LOXDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 18:03:47 -0500
Subject: Re: [PATCH] adding gpmc configuration functions, west bridge
 related
From: Sutharsan <srmt@cypress.com>
To: Greg KH <greg@kroah.com>
Cc: odc@cypress.com, linux-kernel@vger.kernel.org
In-Reply-To: <20101215221837.GA12908@kroah.com>
References: <1292443046.1771.47.camel@sutharsan-laptop>
	 <20101215201029.GA32710@kroah.com>
	 <1292451075.1771.86.camel@sutharsan-laptop>
	 <20101215221837.GA12908@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 15:03:29 -0800
Message-ID: <1292454209.1771.183.camel@sutharsan-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 14:18 -0800, Greg KH wrote:
> A: No.
> Q: Should I include quotations after my reply?
> 
> http://daringfireball.net/2007/07/on_top
Thanks.
> 
> On Wed, Dec 15, 2010 at 02:11:15PM -0800, Sutharsan wrote:
> > Hi Greg,
> > 
> > The driver is in staging area, the patch I submitted is required to get
> > the driver out of staging area.
> 
> But you didn't say that, the patch you sent was not for the staging
> tree, right?
That's right. 
> 
> > This patch is continuation of David Cross'(odc@cypress.com) earlier
> > patch "[PATCH] gpmc, EXPORT_SYMBOLS, west bridge related".
> > 
> > I've modified the driver to use the function exported by "[PATCH] adding
> > gpmc configuration functions, west bridge related". I'll submit the
> > modified driver as another patch.
> 
> that would be good, thanks.
> 
> greg k-h
> 



---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

