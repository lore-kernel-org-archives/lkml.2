Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab2BGUpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 15:45:17 -0500
Received: from imr4.ericy.com ([198.24.6.9]:46597 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756533Ab2BGUpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 15:45:16 -0500
Message-ID: <1328647412.2261.295.camel@groeck-laptop>
Subject: Re: [PATCH 1/3 v2] mfd: Add LPC driver for Intel ICH chipsets
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Jean Delvare <khali@linux-fr.org>
CC: Aaron Sierra <asierra@xes-inc.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>, Peter Tyser <ptyser@xes-inc.com>
Date: Tue, 7 Feb 2012 12:43:32 -0800
In-Reply-To: <20120207213113.5eba9613@endymion.delvare>
References: <19991da0-d4ad-4a62-9ce0-6b7c8d5b7c24@zimbra>
	 <1328645717.2261.286.camel@groeck-laptop>
	 <20120207213113.5eba9613@endymion.delvare>
Organization: Ericsson
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 15:31 -0500, Jean Delvare wrote:
> On Tue, 7 Feb 2012 12:15:17 -0800, Guenter Roeck wrote:
> > Hi Aaron,
> > 
> > On Tue, 2012-02-07 at 14:56 -0500, Aaron Sierra wrote:
> > > This driver currently creates resources for use by a forthcoming ICH
> > > chipset GPIO driver. It could be expanded to created the resources for
> > > converting the esb2rom (mtd) and iTCO_wdt (wdt), and potentially more,
> > > drivers to use the mfd model.
> > > 
> > > Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
> > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > ---
> > 
> > Not sure how to handle this since some of the code is from me ....
> > usually one doesn't add other people's Signed-off unless both are in the
> > commit chain. Comments, anyone ?
> 
> If the code is co-written and you both agree with what the code
> contributed by the other (in terms of Developer's Certificate of
> Origin) then it's IMHO perfectly fine to have two Signed-off-by in the
> submission.
> 
> At any rate it is much better to do that that to commit a known-broken
> patch and have the second contributor fix it afterward.
> 
Ok, makes sense.

Thanks,
Guenter


