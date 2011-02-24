Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab1BXJmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 04:42:19 -0500
Received: from imr4.ericy.com ([198.24.6.8]:35750 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047Ab1BXJmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 04:42:18 -0500
Date: Thu, 24 Feb 2011 01:41:20 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 2/2] hwmon: adt7411: add MODULE_DEVICE_TABLE
Message-ID: <20110224094120.GA5976@ericsson.com>
References: <1298514037.19027.3.camel@mola>
 <1298514121.19027.5.camel@mola>
 <20110224033310.GB4596@ericsson.com>
 <20110224084554.GB4901@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110224084554.GB4901@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 03:45:54AM -0500, Wolfram Sang wrote:
> On Wed, Feb 23, 2011 at 07:33:10PM -0800, Guenter Roeck wrote:
> > On Wed, Feb 23, 2011 at 09:22:01PM -0500, Axel Lin wrote:
> > > The device table is required to load modules based on modaliases.
> > > 
> > > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > 
> > Applied.
> 
> That was fast :)
> 
> FWIW
> 
> Acked-by: Wolfram Sang <w.sang@pengutronix.de>
> 
Thanks!

Guenter

