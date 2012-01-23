Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969Ab2AWPSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:18:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40011 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757Ab2AWPSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:18:33 -0500
Date: Mon, 23 Jan 2012 15:18:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mfd regmap irq to handle some cases
Message-ID: <20120123151830.GA21857@opensource.wolfsonmicro.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED1FDCFCAF@KCHJEXMB01.kpit.com>
 <1327325611.23929.15.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327325611.23929.15.camel@dhruva>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 07:03:31PM +0530, Ashish Jangam wrote:
> On Mon, 2012-01-23 at 19:02 +0530, Ashish Jangam wrote:

> > > > approach for some variants of DA9052 and DA9053 when event is cleared
> > > > a spurious interrupt gets generated therefore in earlier release of
> > > > DA9052/53 MFD module a delay was added. Therefore we need to think on
> > > > how to handle such cases in regmap irq.

> > > What are the consequences of the spurious interrupt?

> There will processing of false events which is undesirable. 

But what actually happens?  RTC interrupts aren't going to be high
volume, if we get the odd spurious interrupt and handle it gracefully
I'm not sure we really care.
