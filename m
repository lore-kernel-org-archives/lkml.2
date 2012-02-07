Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab2BGUb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 15:31:27 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:11749 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab2BGUb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 15:31:26 -0500
Date: Tue, 7 Feb 2012 21:31:13 +0100
From: Jean Delvare <khali@linux-fr.org>
To: guenter.roeck@ericsson.com
Cc: Aaron Sierra <asierra@xes-inc.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>, Peter Tyser <ptyser@xes-inc.com>
Subject: Re: [PATCH 1/3 v2] mfd: Add LPC driver for Intel ICH chipsets
Message-ID: <20120207213113.5eba9613@endymion.delvare>
In-Reply-To: <1328645717.2261.286.camel@groeck-laptop>
References: <19991da0-d4ad-4a62-9ce0-6b7c8d5b7c24@zimbra>
	<1328645717.2261.286.camel@groeck-laptop>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Feb 2012 12:15:17 -0800, Guenter Roeck wrote:
> Hi Aaron,
> 
> On Tue, 2012-02-07 at 14:56 -0500, Aaron Sierra wrote:
> > This driver currently creates resources for use by a forthcoming ICH
> > chipset GPIO driver. It could be expanded to created the resources for
> > converting the esb2rom (mtd) and iTCO_wdt (wdt), and potentially more,
> > drivers to use the mfd model.
> > 
> > Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> 
> Not sure how to handle this since some of the code is from me ....
> usually one doesn't add other people's Signed-off unless both are in the
> commit chain. Comments, anyone ?

If the code is co-written and you both agree with what the code
contributed by the other (in terms of Developer's Certificate of
Origin) then it's IMHO perfectly fine to have two Signed-off-by in the
submission.

At any rate it is much better to do that that to commit a known-broken
patch and have the second contributor fix it afterward.

-- 
Jean Delvare
