Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab1CKRl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 12:41:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44660 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751838Ab1CKRlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 12:41:52 -0500
Date: Fri, 11 Mar 2011 17:41:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>
Cc: Arnd Bergmann <arnd@arndb.de>, andy.green@linaro.org,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110311174149.GW1760@opensource.wolfsonmicro.com>
References: <20110311152938.GB29920@sirena.org.uk>
 <201103111654.04089.arnd@arndb.de>
 <20110311160308.GQ1760@opensource.wolfsonmicro.com>
 <20110311161421.GA7843@kroah.com>
 <20110311162759.GS1760@opensource.wolfsonmicro.com>
 <20110311163522.GA9291@kroah.com>
 <20110311164850.GT1760@opensource.wolfsonmicro.com>
 <20110311165642.GA9996@kroah.com>
 <20110311170807.GV1760@opensource.wolfsonmicro.com>
 <20110311172345.GA10876@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311172345.GA10876@kroah.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 09:23:45AM -0800, Greg KH wrote:
> On Fri, Mar 11, 2011 at 05:08:07PM +0000, Mark Brown wrote:

> > Wrong end of the bus.  This stuff is simple enough to deal with in a
> > system specific fashion, the standard solution would be to patch the
> > relevant drivers to hard code whatever is required.

> What drivers need this?  Specifics please.

I can't discuss specific systems I've seen this on unfortunately.  I
guess the most obvious thing in mainline would be applying quirks like
various drivers have based on data other than device ID information -
it's pretty much the same problem.
