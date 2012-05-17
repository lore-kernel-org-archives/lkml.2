Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762270Ab2EQRt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 13:49:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47105 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762233Ab2EQRt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 13:49:27 -0400
Subject: Re: [PATCH] ARM: mx35: add cpufreq support
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Hans J. Koch" <hjk@hansjkoch.de>, Daniel Mack <daniel@zonque.org>
In-Reply-To: <20120509081306.GK27341@pengutronix.de>
References: <20120507141437.GA9636@lovely.krouter>
	 <20120509072239.GG27341@pengutronix.de>
	 <20120509075618.GA4412@lovely.krouter>
	 <20120509081306.GK27341@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 May 2012 19:49:20 +0200
Message-ID: <1337276960.4970.4.camel@lovely>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 10:13 +0200, Sascha Hauer wrote:
> On Wed, May 09, 2012 at 09:56:18AM +0200, Christoph Fritz wrote:
> > Hi Sascha,
> > 
> > On Wed, May 09, 2012 at 09:22:39AM +0200, Sascha Hauer wrote:
> > > On Mon, May 07, 2012 at 04:14:37PM +0200, Christoph Fritz wrote:
> > > > This patch adds the mx35 to the supported cpu-families of the
> > > > "CPUfreq driver for i.MX CPUs".
> > > 
> > > I'm afraid this has to wait another cycle since you are patching a file
> > > that is scheduled to be replaced with common clock framework support.
> > 
> > Has this "scheduled replacement" somewhere (e.g. calendar) been
> > marked? So that I can check in the future before editing "scheduled
> > files".
> 
> The clock framework conversion has been a hot topic for quite a while
> now, but there hasn't been an official note about it outside the list.
> I can understand that the occasional linux arm kernel reader is not
> aware of it, but we currently have nothing in place to anounce such
> things. (Other than feature-removal.txt which seems not very suitable
> since no feature is removed, only updated)

Is there already a version I can rebase the patch?

On your repo at git://git.pengutronix.de/git/imx/linux-2.6.git I can't
find the new clock framework or even a work-in-progress version.

Thanks,
 -- Christoph

