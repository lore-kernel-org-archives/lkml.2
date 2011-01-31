Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab1AaWJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:09:57 -0500
Received: from ns2.cypress.com ([157.95.67.5]:44951 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756623Ab1AaWJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:09:55 -0500
Subject: Re: [PATCH] Staging: Westbridge: fix EXPORT_SYMBOL errors reported
 by checkpatch.pl
From: Sutharsan <srmt@cypress.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, david.cross@cypress.com
In-Reply-To: <20110131214032.GB1629@kroah.com>
References: <1296061134.4116.7.camel@sutharsan-laptop>
	 <20110131214032.GB1629@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 14:09:38 -0800
Message-ID: <1296511778.1772.33.camel@sutharsan-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-31 at 13:40 -0800, Greg KH wrote:
> On Wed, Jan 26, 2011 at 08:58:54AM -0800, Sutharsan wrote:
> > 
> > From: Sutharsan Ramamoorthy <srmt@cypress.com>
> > 
> > This patch fixes errors reported by checkpatch.pl
> > in westbridge device controller driver in the staging tree.
> > File containing EXPORT_SYMBOL() macros for all the APIs exported
> > by the westbridge software has been removed. EXPORT_SYMBOL() 
> > macros are added after the corresponding function definitions.
> > 
> > Signed-off-by: Sutharsan Ramamoorthy <srmt@cypress.com>
> 
> Why was this sent again?
> totally confused,
I apologize for resending and creating confusion.
There has been a problem with the mail client.
Please ignore this as well.
> 
> greg k-h
> 



---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

