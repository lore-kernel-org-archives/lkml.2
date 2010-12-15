Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab0LOWLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:11:34 -0500
Received: from ns2.cypress.com ([157.95.67.5]:54325 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557Ab0LOWLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:11:31 -0500
Subject: Re: [PATCH] adding gpmc configuration functions, west bridge
 related
From: Sutharsan <srmt@cypress.com>
To: Greg KH <greg@kroah.com>
Cc: odc@cypress.com, linux-kernel@vger.kernel.org
In-Reply-To: <20101215201029.GA32710@kroah.com>
References: <1292443046.1771.47.camel@sutharsan-laptop>
	 <20101215201029.GA32710@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 14:11:15 -0800
Message-ID: <1292451075.1771.86.camel@sutharsan-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

The driver is in staging area, the patch I submitted is required to get
the driver out of staging area. This patch is continuation of David
Cross'(odc@cypress.com) earlier patch "[PATCH] gpmc, EXPORT_SYMBOLS,
west bridge related".

I've modified the driver to use the function exported by "[PATCH] adding
gpmc configuration functions, west bridge related". I'll submit the
modified driver as another patch.

Thanks,
Sutharsan.

On Wed, 2010-12-15 at 12:10 -0800, Greg KH wrote:
> On Wed, Dec 15, 2010 at 11:57:26AM -0800, Sutharsan wrote:
> > 
> > This patch adds and exports gpmc configuration functions. 
> > 'gpmc' configuration functions will be used by westbridge device controller driver.
> 
> So this driver isn't submitted yet?
> 
> Then I would hold off on this until that time when it is needed by that
> other driver.
> 
> Also, any USB related patches should be copied to the
> linux-usb@vger.kernel.org list, and any ARM patches to that related
> list, so next time cc: 2 more lists please.
> 
> thanks,
> 
> greg k-h
> 



---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

